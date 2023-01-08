from bottle import route, run, template
import pickle
import json
from datetime import datetime
import time

filename = "records.pickle"
filename2 = "log.pickle"
records = [(505.6 * 24 * 3600, "Mike")]
log = []

def save_records():
  with open(filename, 'wb') as f:
    pickle.dump(records, f)
  with open(filename2, 'wb') as f:
    pickle.dump(log, f)

def load_records():
  global records, log
  with open(filename, 'rb') as f:
    records = pickle.load(f)
  with open(filename2, 'rb') as f:
    log = pickle.load(f)

@route('/')
def index():
  return json.dumps([[k, v] for v, k in records[:10]])

@route('/<name>/<score>')
def index(name, score):
  if len(name) > 60:
    name = name[:60]
  name = ''.join([c for c in name if c.lower() in "abcdefghijklmnopqrstuvwxyz0123456789-_ "])
  intscore = int(score)
  if (intscore, name) not in records:
    records.append((intscore, name))
    log.append((intscore, name, time.mktime(datetime.now().timetuple())))
    print(log[-1])
  records.sort()
  save_records()
  return json.dumps([[k, v] for v, k in records[:10]])

# save_records()
load_records()
run(host='0.0.0.0', port=80)