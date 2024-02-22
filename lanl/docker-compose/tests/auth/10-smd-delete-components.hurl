# Try deleting a  Component.
DELETE http://smd:27779/hsm/v2/State/Components/x0c0s1b0

# We should not be able to DELETE to Components without a JWT.
HTTP 401
