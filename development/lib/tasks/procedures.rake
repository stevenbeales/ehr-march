namespace :db do
  desc "Create Procedure Model"
  task procedures: :environment do

    Procedure.destroy_all

    def random_tooth_table_id
      rand(1..193)
    end

    def random_procedure_code
      p_code = PROCEDURE_CODES.keys[0..52]
      n = (p_code).to_a
      n.shuffle.first
    end

    def random_status
      rand(0..2)
    end

    def random_encounter_id
      rand(1..193)
    end

    193.times do |nested|
      procedure = Procedure.create do |procedure|
        procedure.tooth_table_id = random_tooth_table_id
        procedure.encounter_id = random_encounter_id
        procedure.procedure_code = random_procedure_code
        procedure.description = Faker::Lorem.sentence(1)
        procedure.date_of_service = Time.now
        procedure.status = random_status
        procedure.surface = Surface.create do |surface|
          surface.mesial = FFaker::Boolean.sample
          surface.incisal = FFaker::Boolean.sample
          surface.distal = FFaker::Boolean.sample
          surface.lingual = FFaker::Boolean.sample
          surface.facial = FFaker::Boolean.sample
          surface.class_five = FFaker::Boolean.sample
        end
        procedure.pit = Pit.create do |pit|
          pit.mesial = FFaker::Boolean.sample
          pit.mesiobuccal = FFaker::Boolean.sample
          pit.mesiolingual = FFaker::Boolean.sample
          pit.distal = FFaker::Boolean.sample
          pit.distobuccal = FFaker::Boolean.sample
          pit.distolingual = FFaker::Boolean.sample
        end
        procedure.cusp = Cusp.create do |cusp|
          cusp.mesiobuccal = FFaker::Boolean.sample
          cusp.mesiolingual = FFaker::Boolean.sample
          cusp.distobuccal = FFaker::Boolean.sample
          cusp.distolingual = FFaker::Boolean.sample
        end
      end
    end

    message = "==== Procedures Created: 193 Procedures ====\r"
    print "\n"
    print message
    $stdout.flush
    sleep 1
  end
end
