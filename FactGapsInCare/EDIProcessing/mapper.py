from pyedi import SchemaMapper
from typing import Union, List, Dict

from .mappings import MAPPINGS

class Mapper:
    """
    Maps EDI 837 claims structured JSON to CSV-friendly flat dictionaries.
    
    Handles single records (dict) and multiple records (list of dicts).
    """

    def __init__(self):
        self.mapper = SchemaMapper(MAPPINGS)

    def map_claims(self, structured_json: Union[Dict, List[Dict]]) -> Union[Dict, List[Dict]]:
        if isinstance(structured_json, list):
            return [self.mapper.map(record) for record in structured_json]
        
        print(f"\n\n\n\nmapped claims: ", self.mapper.map(structured_json))
        return self.mapper.map(structured_json)