import datetime
import json

class User:
  def __init__(self, name, signed_up_at):
    self.name = name
    self.signed_up_at = signed_up_at

  @classmethod
  def decode_from_bytes(cls, encoded_bytes):
    json_string = encoded_bytes.decode('utf-8')
    json_dict = json.loads(json_string)

    name = json_dict['first_name'] + ' ' + json_dict['last name']
    signed_up_at_timestamp = json_dict['signed_up_at']
    signed_up_at = datetime.utcfromtimestamp(signed_up_at_timestamp)
    return cls(name, signed_up_at)

  def encode_to_bytes(self):
    first_name, last_name = self.name.split()
    json_dict = {
      'first_name': first_name,
      'last_name': last_name,
      'signed_up_at': self.signed_up_at.timestamp()
    }

    json_string = json.dumps(json_dict, ensure_ascii=False) # Shhhh
    encoded_bytes = json_string.encode('utf-8')

    return encoded_bytes
