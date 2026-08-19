import json
from pyedi import X12Parser, StructuredFormatter

class EDIProcessor:
    def __init__(self):
        self.parser = X12Parser()
        self.formatter = StructuredFormatter()

    def parse(self, file_path: str):
        # 1. Read the raw EDI file
        print("file path: ", file_path)
        with open(file_path, "r", encoding="utf-8") as file:
            edi_data = file.read()

        # 2. Convert raw EDI text to generic JSON structure
        generic_json = self.parser.parse(edi_data)

        print("\n\n generic json (first 300 chars): ", json.dumps(generic_json, default=str)[:300])

        # 3. Format it immediately into the structured format your pipeline expects
        structured_json = self.formatter.format(
            generic_json,
            include_technical=True
        )

        print("\n\n structured_json (first 300 chars): ", json.dumps(structured_json, default=str)[:300])
        return structured_json