module PatientTreatmentsHelper
  def immunization_registries
    [Patient.immunization_registries,
    ['Don’t sent immunization data. Patient has requested to protect their data.',
     'Send immunization data. Patient has granted permission to release their data.',
     'Patient did not specify preference regarding sharing their data.']].transpose
  end
end
