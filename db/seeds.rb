# Clear existing data
Version.destroy_all
Part.destroy_all
Block.destroy_all
Model.destroy_all
Type.destroy_all

# Create Types
type1 = Type.create(type_name: 'Electronic', type_number: '0001', description: 'Electronic components')
type2 = Type.create(type_name: 'Mechanical', type_number: '0002', description: 'Mechanical components')

# Create Models
model1 = Model.create(model_code: 'E1001', description: 'Electronic Model 1', type: type1)
model2 = Model.create(model_code: 'E1002', description: 'Electronic Model 2', type: type1)
model3 = Model.create(model_code: 'M2001', description: 'Mechanical Model 1', type: type2)

# Create Blocks
block1 = Block.create(block_number: '0001-001', block_name: 'Main Board', description: 'Main electronic board')
block2 = Block.create(block_number: '0001-002', block_name: 'Power Supply', description: 'Power supply unit')
block3 = Block.create(block_number: '0002-001', block_name: 'Engine', description: 'Mechanical engine')

# Associate Blocks with Models
block1.models << model1
block1.models << model2
block2.models << model1
block3.models << model3

# Create Parts
part1 = Part.create(part_number: '0001-001-001', part_name: 'Capacitor', description: '10uF Capacitor')
part2 = Part.create(part_number: '0001-001-002', part_name: 'Resistor', description: '100 Ohm Resistor')
part3 = Part.create(part_number: '0002-001-001', part_name: 'Piston', description: 'Engine Piston')

# Associate Parts with Blocks
block1.parts << part1
block1.parts << part2
block2.parts << part1
block3.parts << part3

# Create Versions
Version.create(version_number: '0001-001-001-001', description: 'Initial version', part: part1)
Version.create(version_number: '0001-001-001-002', description: 'Updated version', part: part1)
Version.create(version_number: '0001-001-002-001', description: 'Initial version', part: part2)
Version.create(version_number: '0002-001-001-001', description: 'Initial version', part: part3)
