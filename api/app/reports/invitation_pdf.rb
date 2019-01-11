class InvitationPdf < Prawn::Document

  def logo
    logopath =  "#{Rails.root}/app/assets/images/header-pdf.png"
    image logopath, :width => 522, :height => 100, :position => :center
  end

  def initialize(name, birth, code)
    super()
    self.line_width = 2
    font_families.update(
        "Verdana" => {
            :bold => "/home/deployer/new-development/app/assets/fonts/timesnewromanb.ttf",
            :italic => "/home/deployer/new-development/app/assets/fonts/timesnewromani.ttf",
            :normal  => "/home/deployer/new-development/app/assets/fonts/timesnewr.ttf"
        })

    stroke_color "#FFFFCC"
    stroke do
      rounded_rectangle [9, 721], 523, 720, 5
      logo
    end
    move_down 50
    text_box "Dear, #{name}", at: [35, 580], size: 10
    text_box "You have been invited to access your health records in your EHR 1 Patient Portal.", at: [35, 550], size: 10
    text_box "View upcoming appointment, care notes from your recent appointment(s), send a secure message", at: [35, 520], size: 10
    text_box "the practice or your provider, and more!", at: [35, 508], size: 10
    text_box "To setup your account, first make sure to contact your practice for a Security Access Code:", at: [35, 470], size: 10
    stroke_rounded_rectangle [100, 430], 320, 80, 5
    text_box "Then, go to the link below and follow the instructions on the page to complete setting up your Patient", at: [35, 320], size: 10
    text_box "Portal account.", at: [35, 308], size: 10
    text_box "http://www.ehr1denal.com/new-patient-portal-setup/", at: [125, 265], size: 12
    text_box "Sincerely,", at: [35, 220], size: 10
    text_box "EHR1 Team", at: [35, 190], size: 10

    fill_gradient [48, 100], [100, 200], '#9DDDDD', '#9DDDDD'
    fill_rectangle [9, 50], 523, 48
    rounded_rectangle [9, 50], 523, 48, 5
    fill_color "#000"
    text_box "#{code}", at: [240, 395], size: 14
    text_box "© 2015 EHR One, LLC", at: [50, 28], size: 10
  end
end
