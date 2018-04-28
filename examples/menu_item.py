import json

class MenuItem:
  def __init__(self, name, cents):
    self.name = name
    self.cents = cents

  @classmethod
  def decode_from_bytes(cls, encoded_bytes):
    json_string = encoded_bytes.decode('utf-8')
    json_dict = json.loads(json_string)

    name = json_dict['name']
    cents = json_dict['price']

    return cls(name, cents)

  def encode_to_bytes(self):
    json_dict = {
      'name': self.name,
      'price': self.cents
    }

    json_string = json.dumps(json_dict)
    encoded_bytes = json_string.encode('utf-8')

    return encoded_bytes
