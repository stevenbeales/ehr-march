namespace :db do
  desc "Create Subject Model"
  task subjects: :environment do

    Subject.destroy_all

    [
        'Wellness Check-up Reminder',
        'Please Confirm Your Appointment',
        'Recent Lab Results Available',
        'Recent Imaging Results',
        'Clinical Summary Document Available',
        'Please Contact Our Office'
    ].each do |name|
      Subject.create(name: name)
    end

    message = "==== Subjects Created ====\r"
    print "\n"
    print message
    $stdout.flush
    sleep 1
  end
end
