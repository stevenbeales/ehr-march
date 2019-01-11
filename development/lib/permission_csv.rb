require 'csv'

class PermissionCsv
  PERMISSION_LIST_FILENAME = 'permission_list.csv'

  def self.parse_and_create_csv
    File.delete(PERMISSION_LIST_FILENAME) if File.exist?(PERMISSION_LIST_FILENAME)
    CSV.open(PERMISSION_LIST_FILENAME, 'wb') do |csv|
      policies = Dir.entries(Rails.root.join('app', 'policies')).reject{
        |file| %w(. .. admin_policy.rb base_policy.rb provider_policy.rb).include? file
      }.map{ |file| File.basename(file, '.rb').camelcase }

      policies.each do |policy|
        methods = policy.constantize.instance_methods(false)
        methods.each do |method|
          csv << ["#{policy.underscore.gsub('_policy', '').humanize} #{method.to_s.humanize(capitalize: false)}",
                  "#{policy}##{method}",
                  true,
                  true,
                  true,
                  true,
                  true]
        end
      end

    end
  end

  def self.set_default_permissions_from_csv(provider)
    practice_roles = [:Admin, :Dentist, :Hygientist, :'Back Office', :'Front Desk']
    if provider.present?
      CSV.foreach(PERMISSION_LIST_FILENAME) do |csv|
        permission = Permission.create(presentation: csv[0],
                                       policy_name:  csv[1],
                                       provider_id:  provider.id)
        (2..6).to_a.each do |i|
          Availability.create(role: practice_roles[i - 2],
                              available: csv[i],
                              permission_id: permission.id)
        end
      end
    end
  end

  # run PermissionCsv.reload if you add new policy or change something
  # WARNING! This method will set all permissions to default
  def self.reload
    parse_and_create_csv

    Provider.each do |provider|
      provider.permissions.destroy_all
      set_default_permissions_from_csv(provider)
    end
  end
end
