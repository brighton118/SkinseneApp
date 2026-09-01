import requests, time

url = 'https://skinsense-backend-240757536793.us-central1.run.app/v1/assessments'
print('1. Creating assessment...')
t0 = time.time()
res = requests.post(url).json()
assesid = res['id']
print('Created in', time.time()-t0, 'sec:', assesid)

print('2. Uploading image...')
t0 = time.time()
# create dummy image
with open('dummy.jpg', 'wb') as f:
    f.write(b'\xFF\xD8\xFF\xE0\x00\x10\x4A\x46\x49\x46\x00\x01\x01\x01\x00\x48\x00\x48\x00\x00\xFF\xDB\x00\x43\x00\x08\x06\x06\x07\x06\x05\x08\x07\x07\x07\x09\x09\x08\x0A\x0C\x14\x0D\x0C\x0B\x0B\x0C\x19\x12\x13\x0F\x14\x1D\x1A\x1F\x1E\x1D\x1A\x1C\x1C\x20\x24\x2E\x27\x20\x22\x2C\x23\x1C\x1C\x28\x37\x29\x2C\x30\x31\x34\x34\x34\x1F\x27\x39\x3D\x38\x32\x3C\x2E\x33\x34\x32\xFF\xC0\x00\x0B\x08\x00\x01\x00\x01\x01\x01\x11\x00\xFF\xDA\x00\x08\x01\x01\x00\x00\x3F\x00\xD2\xFF\xD9')

with open('dummy.jpg', 'rb') as f:
    res = requests.post(f"{url}/{assesid}/image-assessment", files={'image': f}).json()
print('Uploaded in', time.time()-t0, 'sec:', res)

print('3. Questionnaire...')
t0 = time.time()
q = {
    'duration': 'less_than_one_week',
    'itching': 'no',
    'pain_level': 1,
    'rapidly_spreading': 'no',
    'affected_body_area': 'face_or_neck',
    'fever': 'no',
    'high_fever': 'no',
    'swelling': 'no',
    'difficulty_breathing': 'no',
    'lip_tongue_throat_swelling': 'no',
    'bleeding': 'no',
    'blistering': 'no',
    'open_wound': 'no',
    'eye_involvement': 'no',
    'possible_infection': 'no',
    'age_group': 'adult',
    'recurrent': 'no',
}
res = requests.put(f"{url}/{assesid}/questionnaire", json=q).json()
print('Questionnaire saved in', time.time()-t0, 'sec:', res)

print('4. Recommendations...')
t0 = time.time()
res = requests.post(f"{url}/{assesid}/recommendation", timeout=120).json()
print('Recommendations generated in', time.time()-t0, 'sec', res)
