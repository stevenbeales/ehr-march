class SmokingStatus
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.statuses
    statuses_with_codes.keys
  end

  def self.statuses_with_codes
    {
        :'Never Smoked Ever' => '266919005',
        :'Current Every Day Smoker' => '449868002',
        :'Unknown if Ever Smoked' => '266927001',
        :'Current Some Day Smoker' => '428041000124106',
        :'Former Smoker' => '8517006',
        :'Heavy Tobacco Smoker' => '428071000124103',
        :'Smoker, Current Status Unknown' => '77176002',
        :'Light Tobacco Smoker' => '428061000124105'
    }
  end

  field :status,         type: Enum, in: self.statuses, default: self.statuses.first
  field :effective_from, type: Time

  belongs_to :patient
end
