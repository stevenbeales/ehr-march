FactoryGirl.define do
  factory :immunization do
    association             :patient
    vaccine_id               { Vaccine.first.try(:id) }
    administered_by_id       { Provider.first.try(:id) }
    ordered_by_id            { Provider.first.try(:id) }
    administered_facility_id { Provider.first.try(:location).try(:id) }
    facility_id              { Provider.first.try(:location).try(:id) }
    name                     { Immunization.names.first }
    administered_at          { Time.now }
    refused_at               { nil }
    source_of_information    { Immunization.source_of_informations.sample }
    reason_refused           { Immunization.reason_refuseds.sample }
    manufacturer             { Immunization.manufacturers.sample }
    lot                      { Faker::Lorem.word }
    quantity                 { Faker::Lorem.word }
    dose                     { Faker::Lorem.word }
    unit                     { Immunization.units.sample }
    expiration_at            { Time.now }
    route                    { Immunization.routes.sample }
    body_site                { Immunization.body_sites.sample }
    funding_source           { Immunization.funding_sources.sample }
    registry_notification    { Immunization.registry_notifications.sample }
    vfc_class                { Immunization.vfc_classes.sample }
    comments                 { Faker::Lorem.sentence }
  end
end
