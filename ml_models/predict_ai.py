#!/usr/bin/env python3
"""
Pre-eclampsia AI Prediction Engine
Uses checklist_model.pkl with clinical safety overrides
"""

import sys
import json
import base64
import os
import warnings
import numpy as np

# Silence warnings and background logs completely to ensure clean JSON streams
warnings.filterwarnings("ignore")

try:
    import joblib
    HAS_JOBLIB = True
except ImportError:
    HAS_JOBLIB = False

# ============================================
# MODEL LOADING (ABSOLUTE DIRECTORY)
# ============================================

def load_model_assets():
    """Load the trained machine learning models from /models folder using absolute paths"""
    models_dir = 'C:\\xampp\\htdocs\\mothercare\\models'
    
    model_data = {
        'checklist_model': None,
        'tfidf_vectorizer': None,
        'nlp_model': None,
        'feature_columns': []
    }
    
    checklist_path = os.path.join(models_dir, 'checklist_model.pkl')
    if os.path.exists(checklist_path):
        try:
            if HAS_JOBLIB:
                model_data['checklist_model'] = joblib.load(checklist_path)
            else:
                import pickle
                with open(checklist_path, 'rb') as f:
                    model_data['checklist_model'] = pickle.load(f)
        except Exception:
            pass
            
    features_path = os.path.join(models_dir, 'features.json')
    if os.path.exists(features_path):
        try:
            with open(features_path, 'r') as f:
                model_data['feature_columns'] = json.load(f)
        except Exception:
            pass
            
    return model_data

# ============================================
# CLINICAL OVERRIDE FUNCTIONS (WHO)
# ============================================

def get_clinical_risk_level(systolic_bp, diastolic_bp, proteinuria, symptoms_list):
    """Determine risk level based on clinical parameters (WHO Guidelines)"""
    s = ' '.join(symptoms_list).lower()
    
    if systolic_bp >= 160 or diastolic_bp >= 110:
        return "Critical", 95
    if systolic_bp >= 140 or diastolic_bp >= 90:
        return "High", 75
        
    severe_symptoms = ['headache', 'blurred vision', 'abdominal pain', 'shortness of breath']
    severe_count = sum(1 for sym in severe_symptoms if sym in s)
    
    if severe_count >= 3:
        return "High", 70
    elif severe_count >= 2:
        return "Moderate", 50
        
    if proteinuria in ['Yes', 'Positive', 'yes', 'positive', '1+', '2+', '3+', '4+']:
        return "High", 65
    elif proteinuria in ['Trace', 'trace']:
        return "Moderate", 45
        
    return None, None

def get_advice(risk_score, level, facility=None):
    """Generate advice matching risk matrix metrics"""
    f = facility if facility else "your nearest health facility"
    
    if risk_score < 25:
        return f"LOW RISK\n\nRisk Score: {risk_score}%\n\n✅ Continue routine antenatal care\n✅ Monitor blood pressure weekly\n✅ Watch for new symptoms\n\n📅 Next appointment: {f}"
    elif risk_score < 55:
        return f"MODERATE RISK\n\nRisk Score: {risk_score}%\n\n📋 Recommended Actions:\n• Check BP DAILY\n• Reduce salt intake\n• Rest on left side\n• Monitor warning signs\n\n🏥 Visit {f} within 2 weeks"
    elif risk_score < 80:
        return f"HIGH RISK - URGENT\n\nRisk Score: {risk_score}%\n\n⚠️ Go to {f} TODAY or TOMORROW\n• Check BP TWICE daily\n• Strict bed rest\n• Low salt diet\n• Monitor fetal movement\n\n🚨 EMERGENCY: Go NOW if convulsions, severe headache, vision changes, difficulty breathing"
    else:
        return f"CRITICAL RISK - EMERGENCY\n\nRisk Score: {risk_score}%\n\n🚑 GO TO {f} NOW\n• Call emergency services (112)\n• DO NOT WAIT\n• Do not drive yourself\n\n🚨 EMERGENCY SIGNS:\n• Convulsions\n• Loss of consciousness\n• Severe headache\n• Visual changes\n• Difficulty breathing\n• Severe abdominal pain"

def predict_with_checklist(model, features_dict, feature_columns):
    """Make prediction using the checklist model"""
    try:
        feature_list = [int(features_dict.get(col, 0)) for col in feature_columns]
        features_array = np.array([feature_list])
        
        proba = model.predict_proba(features_array)[0]
        classes = model.classes_
        
        max_idx = np.argmax(proba)
        pred_label = str(classes[max_idx])
        
        risk_map = {"Green": 15, "Yellow": 45, "Red": 75, "Low": 15, "Moderate": 45, "High": 75, "Critical": 95}
        return pred_label, risk_map.get(pred_label, 50)
    except Exception:
        return "Moderate", 50

# ============================================
# MAIN INTERFACE RUNNER
# ============================================

def main():
    try:
        if len(sys.argv) < 2:
            raise ValueError("Payload variable argument omitted.")
            
        b64_string = sys.argv[1]
        json_data = base64.b64decode(b64_string).decode('utf-8')
        payload = json.loads(json_data)
        
        symptoms_input = payload.get('symptoms', [])
        systolic_bp = int(payload.get('systolic_bp', 0))
        diastolic_bp = int(payload.get('diastolic_bp', 0))
        proteinuria = str(payload.get('proteinuria', 'None'))
        facility = payload.get('user_profile', {}).get('nearest_health', 'your nearest health facility')
        
        if isinstance(symptoms_input, list):
            symptoms_list = [str(s).lower() for s in symptoms_input]
        else:
            symptoms_list = [s.strip().lower() for s in str(symptoms_input).split(',') if s.strip()]

        # 1. Apply safety overrides
        level, risk_score = get_clinical_risk_level(systolic_bp, diastolic_bp, proteinuria, symptoms_list)
        
        # 2. Evaluate ML models if no emergency override triggered
        if level is None:
            assets = load_model_assets()
            if assets['checklist_model'] is not None and len(assets['feature_columns']) > 0:
                features_dict = {sym: 1 for sym in symptoms_list}
                level, risk_score = predict_with_checklist(assets['checklist_model'], features_dict, assets['feature_columns'])
            else:
                # Force runtime script error to fall back safely to PHP algorithms if assets missing
                raise FileNotFoundError("Model assets missing from system pipeline paths.")

        advice = get_advice(risk_score, level, facility)
        
        output = {
            "status": "success",
            "success": True,
            "risk": risk_score,
            "level": level,
            "note": advice,
            "prediction": advice
        }
        print(json.dumps(output))

    except Exception as e:
        # Pass structured runtime failure to drop into PHP's rule matrix cleanly
        print(json.dumps({"status": "error", "success": False, "message": str(e)}))

if __name__ == "__main__":
    main()
