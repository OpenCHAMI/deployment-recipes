# Check that fetching Components without specifying an xname works.
GET http://smd-noauth:27779/hsm/v2/State/Components
# Response should have >0 entry with a successful return code.
HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$.[*]" count > 0
