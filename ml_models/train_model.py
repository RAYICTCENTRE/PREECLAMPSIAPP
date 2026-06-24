# train_model.py
import os
import json
import random
import pickle
import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.feature_extraction.text import TfidfVectorizer

print("1. Generating 1,500+ WHO-aligned synthetic clinical records...")

# Seed for reproducibility
random.seed(42)
np.random.seed(42)

# Defined clinical features (Checklist symptoms)
feature_cols = [
    "fever", "severe_headache", "visual_disturbances", 
    "epigastric_pain", "sudden_swelling", "shortness_of_breath"
]

# NLP text templates following standard clinical descriptions
nlp_templates = {
    "Red": [
        "I have a splitting headache that won't go away and blurry vision.",
        "Severe pain right under my ribs and my hands are completely swollen.",
        "Chest feels tight and I cannot catch my breath at all.",
        "Terrible flashing lights in my eyes and worst headache of my life.",
        "Sudden extreme swelling in my face and breathing is very difficult."
    ],
    "Yellow": [
        "Mild headache for a few hours and feeling a bit tired.",
        "Slight puffiness in my ankles and feet since this morning.",
        "Having some mild stomach discomfort right under my ribs.",
        "Vision feels a tiny bit fuzzy but no severe pain yet.",
        "Lately feeling slightly short of breath when walking up stairs."
    ],
    "Green": [
        "Routine checkup, feeling normal with standard fatigue.",
        "No major complaints just normal pregnancy backache.",
        "Slept poorly last night but no headache or swelling.",
        "Just logging symptoms for tracking, feeling healthy today.",
        "Slightly warm but no fever or visual issues."
    ]
}

dataset = []

for _ in range(1550):
    # Determine synthetic profile risk class to create an even distribution
    risk_class = random.choices(["Green", "Yellow", "Red"], weights=[0.4, 0.3, 0.3])[0]
    
    # Initialize baseline symptoms
    row = {col: 0 for col in feature_cols}
    
    if risk_class == "Red":
        # Critical clinical criteria matching severe preeclampsia markers
        row["severe_headache"] = random.choices([0, 1], weights=[0.2, 0.8])[0]
        row["visual_disturbances"] = random.choices([0, 1], weights=[0.3, 0.7])[0]
        row["epigastric_pain"] = random.choices([0, 1], weights=[0.4, 0.6])[0]
        row["shortness_of_breath"] = random.choices([0, 1], weights=[0.5, 0.5])[0]
        row["sudden_swelling"] = random.choices([0, 1], weights=[0.3, 0.7])[0]
        # Ensure at least one severe marker is active if randomly missed
        if sum(row.values()) == 0:
            row["severe_headache"] = 1
            
    elif risk_class == "Yellow":
        row["severe_headache"] = random.choices([0, 1], weights=[0.7, 0.3])[0]
        row["sudden_swelling"] = random.choices([0, 1], weights=[0.5, 0.5])[0]
        row["epigastric_pain"] = random.choices([0, 1], weights=[0.8, 0.2])[0]
        # Restrict critical combos to keep them out of Red category bounds
        row["visual_disturbances"] = 0 
        row["shortness_of_breath"] = 0
        
    else: # Green
        row["fever"] = random.choices([0, 1], weights=[0.95, 0.05])[0] # unrelated tracking
    
    # Assign a corresponding NLP text variant with added randomized noise
    base_text = random.choice(nlp_templates[risk_class])
    noise = random.choice(["", " Feeling anxious.", " Please advise.", " Started today.", " Progressively worse."])
    row["typed_text"] = base_text + noise
    row["label"] = risk_class
    
    dataset.append(row)

df = pd.DataFrame(dataset)

print("2. Training structured checklist Logistic Regression model...")
X_checklist = df[feature_cols]
y = df["label"]

checklist_model = LogisticRegression(max_iter=1000, class_weight='balanced')
checklist_model.fit(X_checklist, y)

print("3. Training text NLP (TF-IDF + Logistic Regression) model...")
tfidf = TfidfVectorizer(stop_words='english', max_features=500)
X_text = tfidf.fit_transform(df["typed_text"])

nlp_model = LogisticRegression(max_iter=1000, class_weight='balanced')
nlp_model.fit(X_text, y)

print("4. Serializing and exporting production model assets...")
models_dir = 'models'
os.makedirs(models_dir, exist_ok=True)

with open(os.path.join(models_dir, 'checklist_model.pkl'), 'wb') as f:
    pickle.dump(checklist_model, f)

with open(os.path.join(models_dir, 'tfidf_vectorizer.pkl'), 'wb') as f:
    pickle.dump(tfidf, f)

with open(os.path.join(models_dir, 'nlp_model.pkl'), 'wb') as f:
    pickle.dump(nlp_model, f)

# Save feature layout definitions for use in inference tracking
with open(os.path.join(models_dir, 'features.json'), 'w') as f:
    json.dump(feature_cols, f)

print("Successfully trained models! Files saved securely to the '/models' directory.")
