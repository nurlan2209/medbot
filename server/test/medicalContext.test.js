const test = require('node:test');
const assert = require('node:assert/strict');
const { buildMedicalContext } = require('../utils/medicalContext');

test('buildMedicalContext returns formatted context from medical card', () => {
  const user = {
    settings: { useMedicalDataInAI: true },
    medicalCard: {
      personalInfo: {
        name: 'Alex Doe',
        dateOfBirth: '2000-01-01',
        bloodType: 'O+',
        height: '170 cm',
        weight: '60 kg',
      },
      chronicConditions: ['Asthma'],
      allergies: [{ name: 'Peanuts', severity: 'high' }],
      currentMedications: [{ name: 'Ibuprofen', dosage: '200mg', frequency: 'daily' }],
    },
  };

  const context = buildMedicalContext(user);

  assert.ok(context);
  assert.match(context, /Name: Alex Doe/);
  assert.match(context, /Chronic Conditions: Asthma/);
  assert.match(context, /Allergies: Peanuts \(high\)/);
  assert.match(context, /Current Medications: Ibuprofen 200mg/);
  assert.match(context, /daily/);
});
