require 'api_documentation_helper'

RSpec.resource 'Tooth table' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/patient_treatments/tooth_activity' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }

    parameter :auth_token, 'Authentication Token',                           scope: :data,   required: true
    parameter :id,         'Tooth id, tooth must be active',                 scope: :data,   required: true
    parameter :active,     'Boolean, if true - set tooth table to active',   scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { patient.tooth_tables.first.id }
    let(:active)     { true }

    example_request 'Set tooth table activity' do
      expect(status).to eq 200
      expect(ToothTable.find(id).active).to eq true
    end
  end

  get '/patient_treatments/show_patient_full_perio' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }

    parameter :auth_token, 'Authentication Token',             scope: :data,   required: true
    parameter :id,         'Tooth id, tooth must be active',   scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { patient.tooth_tables.first.id }

    example_request 'Get tooth' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(patient.tooth_tables.first).to_json
    end
  end

  patch '/patient_treatments/update_full_perio' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }

    parameter :auth_token, 'Authentication Token',                                  required: true
    parameter :id,         'Tooth id, tooth must be active',  scope: :tooth_table,   required: true

    parameter :fm_f,       'Fm f',       scope: :tooth_table
    parameter :fm_m,       'Fm m',       scope: :tooth_table
    parameter :mgl,        'Mgl',        scope: :tooth_table
    parameter :cal,        'Cal',        scope: :tooth_table
    parameter :pd,         'Pd',         scope: :tooth_table
    parameter :gm,         'Gm',         scope: :tooth_table
    
    parameter :b1,                       scope: [ :tooth_table, :mgl ]
    parameter :b2,                       scope: [ :tooth_table, :mgl ]
    parameter :b3,                       scope: [ :tooth_table, :mgl ]
    parameter :b_bsp1,                   scope: [ :tooth_table, :mgl ]
    parameter :b_bsp2,                   scope: [ :tooth_table, :mgl ]
    parameter :b_bsp3,                   scope: [ :tooth_table, :mgl ]
    parameter :b_bsp4,                   scope: [ :tooth_table, :mgl ]
    parameter :b_bsp5,                   scope: [ :tooth_table, :mgl ]
    parameter :b_bsp6,                   scope: [ :tooth_table, :mgl ]
    parameter :b_bsp7,                   scope: [ :tooth_table, :mgl ]
    parameter :b_bsp8,                   scope: [ :tooth_table, :mgl ]
    parameter :b_bsp9,                   scope: [ :tooth_table, :mgl ]
    parameter :l1,                       scope: [ :tooth_table, :mgl ]
    parameter :l2,                       scope: [ :tooth_table, :mgl ]
    parameter :l3,                       scope: [ :tooth_table, :mgl ]
    parameter :l_bsp1,                   scope: [ :tooth_table, :mgl ]
    parameter :l_bsp2,                   scope: [ :tooth_table, :mgl ]
    parameter :l_bsp3,                   scope: [ :tooth_table, :mgl ]
    parameter :l_bsp4,                   scope: [ :tooth_table, :mgl ]
    parameter :l_bsp5,                   scope: [ :tooth_table, :mgl ]
    parameter :l_bsp6,                   scope: [ :tooth_table, :mgl ]
    parameter :l_bsp7,                   scope: [ :tooth_table, :mgl ]
    parameter :l_bsp8,                   scope: [ :tooth_table, :mgl ]
    parameter :l_bsp9,                   scope: [ :tooth_table, :mgl ]

    parameter :b1,                       scope: [ :tooth_table, :cal ]
    parameter :b2,                       scope: [ :tooth_table, :cal ]
    parameter :b3,                       scope: [ :tooth_table, :cal ]
    parameter :b_bsp1,                   scope: [ :tooth_table, :cal ]
    parameter :b_bsp2,                   scope: [ :tooth_table, :cal ]
    parameter :b_bsp3,                   scope: [ :tooth_table, :cal ]
    parameter :b_bsp4,                   scope: [ :tooth_table, :cal ]
    parameter :b_bsp5,                   scope: [ :tooth_table, :cal ]
    parameter :b_bsp6,                   scope: [ :tooth_table, :cal ]
    parameter :b_bsp7,                   scope: [ :tooth_table, :cal ]
    parameter :b_bsp8,                   scope: [ :tooth_table, :cal ]
    parameter :b_bsp9,                   scope: [ :tooth_table, :cal ]
    parameter :l1,                       scope: [ :tooth_table, :cal ]
    parameter :l2,                       scope: [ :tooth_table, :cal ]
    parameter :l3,                       scope: [ :tooth_table, :cal ]
    parameter :l_bsp1,                   scope: [ :tooth_table, :cal ]
    parameter :l_bsp2,                   scope: [ :tooth_table, :cal ]
    parameter :l_bsp3,                   scope: [ :tooth_table, :cal ]
    parameter :l_bsp4,                   scope: [ :tooth_table, :cal ]
    parameter :l_bsp5,                   scope: [ :tooth_table, :cal ]
    parameter :l_bsp6,                   scope: [ :tooth_table, :cal ]
    parameter :l_bsp7,                   scope: [ :tooth_table, :cal ]
    parameter :l_bsp8,                   scope: [ :tooth_table, :cal ]
    parameter :l_bsp9,                   scope: [ :tooth_table, :cal ]

    parameter :b1,                       scope: [ :tooth_table, :pd ]
    parameter :b2,                       scope: [ :tooth_table, :pd ]
    parameter :b3,                       scope: [ :tooth_table, :pd ]
    parameter :b_bsp1,                   scope: [ :tooth_table, :pd ]
    parameter :b_bsp2,                   scope: [ :tooth_table, :pd ]
    parameter :b_bsp3,                   scope: [ :tooth_table, :pd ]
    parameter :b_bsp4,                   scope: [ :tooth_table, :pd ]
    parameter :b_bsp5,                   scope: [ :tooth_table, :pd ]
    parameter :b_bsp6,                   scope: [ :tooth_table, :pd ]
    parameter :b_bsp7,                   scope: [ :tooth_table, :pd ]
    parameter :b_bsp8,                   scope: [ :tooth_table, :pd ]
    parameter :b_bsp9,                   scope: [ :tooth_table, :pd ]
    parameter :l1,                       scope: [ :tooth_table, :pd ]
    parameter :l2,                       scope: [ :tooth_table, :pd ]
    parameter :l3,                       scope: [ :tooth_table, :pd ]
    parameter :l_bsp1,                   scope: [ :tooth_table, :pd ]
    parameter :l_bsp2,                   scope: [ :tooth_table, :pd ]
    parameter :l_bsp3,                   scope: [ :tooth_table, :pd ]
    parameter :l_bsp4,                   scope: [ :tooth_table, :pd ]
    parameter :l_bsp5,                   scope: [ :tooth_table, :pd ]
    parameter :l_bsp6,                   scope: [ :tooth_table, :pd ]
    parameter :l_bsp7,                   scope: [ :tooth_table, :pd ]
    parameter :l_bsp8,                   scope: [ :tooth_table, :pd ]
    parameter :l_bsp9,                   scope: [ :tooth_table, :pd ]

    parameter :b1,                       scope: [ :tooth_table, :gm ]
    parameter :b2,                       scope: [ :tooth_table, :gm ]
    parameter :b3,                       scope: [ :tooth_table, :gm ]
    parameter :b_bsp1,                   scope: [ :tooth_table, :gm ]
    parameter :b_bsp2,                   scope: [ :tooth_table, :gm ]
    parameter :b_bsp3,                   scope: [ :tooth_table, :gm ]
    parameter :b_bsp4,                   scope: [ :tooth_table, :gm ]
    parameter :b_bsp5,                   scope: [ :tooth_table, :gm ]
    parameter :b_bsp6,                   scope: [ :tooth_table, :gm ]
    parameter :b_bsp7,                   scope: [ :tooth_table, :gm ]
    parameter :b_bsp8,                   scope: [ :tooth_table, :gm ]
    parameter :b_bsp9,                   scope: [ :tooth_table, :gm ]
    parameter :l1,                       scope: [ :tooth_table, :gm ]
    parameter :l2,                       scope: [ :tooth_table, :gm ]
    parameter :l3,                       scope: [ :tooth_table, :gm ]
    parameter :l_bsp1,                   scope: [ :tooth_table, :gm ]
    parameter :l_bsp2,                   scope: [ :tooth_table, :gm ]
    parameter :l_bsp3,                   scope: [ :tooth_table, :gm ]
    parameter :l_bsp4,                   scope: [ :tooth_table, :gm ]
    parameter :l_bsp5,                   scope: [ :tooth_table, :gm ]
    parameter :l_bsp6,                   scope: [ :tooth_table, :gm ]
    parameter :l_bsp7,                   scope: [ :tooth_table, :gm ]
    parameter :l_bsp8,                   scope: [ :tooth_table, :gm ]
    parameter :l_bsp9,                   scope: [ :tooth_table, :gm ]

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { patient.tooth_tables.first.id }
    let(:fm_f)       { 0 }
    let(:fm_m)       { 0 }
    
    let(:tooth_table_mgl_b1)     { 1 }
    let(:tooth_table_mgl_b2)     { 2 }
    let(:tooth_table_mgl_b3)     { 3 }
    let(:tooth_table_mgl_b_bsp1) { true }
    let(:tooth_table_mgl_b_bsp2) { true }
    let(:tooth_table_mgl_b_bsp3) { true }
    let(:tooth_table_mgl_b_bsp4) { true }
    let(:tooth_table_mgl_b_bsp5) { true }
    let(:tooth_table_mgl_b_bsp6) { true }
    let(:tooth_table_mgl_b_bsp7) { true }
    let(:tooth_table_mgl_b_bsp8) { true }
    let(:tooth_table_mgl_b_bsp9) { true }
    let(:tooth_table_mgl_l1)     { 1 }
    let(:tooth_table_mgl_l2)     { 2 }
    let(:tooth_table_mgl_l3)     { 3 }
    let(:tooth_table_mgl_l_bsp1) { true }
    let(:tooth_table_mgl_l_bsp2) { true }
    let(:tooth_table_mgl_l_bsp3) { true }
    let(:tooth_table_mgl_l_bsp4) { true }
    let(:tooth_table_mgl_l_bsp5) { true }
    let(:tooth_table_mgl_l_bsp6) { true }
    let(:tooth_table_mgl_l_bsp7) { true }
    let(:tooth_table_mgl_l_bsp8) { true }
    let(:tooth_table_mgl_l_bsp9) { true }

    let(:tooth_table_cal_b1)     { 1 }
    let(:tooth_table_cal_b2)     { 2 }
    let(:tooth_table_cal_b3)     { 3 }
    let(:tooth_table_cal_b_bsp1) { true }
    let(:tooth_table_cal_b_bsp2) { true }
    let(:tooth_table_cal_b_bsp3) { true }
    let(:tooth_table_cal_b_bsp4) { true }
    let(:tooth_table_cal_b_bsp5) { true }
    let(:tooth_table_cal_b_bsp6) { true }
    let(:tooth_table_cal_b_bsp7) { true }
    let(:tooth_table_cal_b_bsp8) { true }
    let(:tooth_table_cal_b_bsp9) { true }
    let(:tooth_table_cal_l1)     { 1 }
    let(:tooth_table_cal_l2)     { 2 }
    let(:tooth_table_cal_l3)     { 3 }
    let(:tooth_table_cal_l_bsp1) { true }
    let(:tooth_table_cal_l_bsp2) { true }
    let(:tooth_table_cal_l_bsp3) { true }
    let(:tooth_table_cal_l_bsp4) { true }
    let(:tooth_table_cal_l_bsp5) { true }
    let(:tooth_table_cal_l_bsp6) { true }
    let(:tooth_table_cal_l_bsp7) { true }
    let(:tooth_table_cal_l_bsp8) { true }
    let(:tooth_table_cal_l_bsp9) { true }

    let(:tooth_table_pd_b1)     { 1 }
    let(:tooth_table_pd_b2)     { 2 }
    let(:tooth_table_pd_b3)     { 3 }
    let(:tooth_table_pd_b_bsp1) { true }
    let(:tooth_table_pd_b_bsp2) { true }
    let(:tooth_table_pd_b_bsp3) { true }
    let(:tooth_table_pd_b_bsp4) { true }
    let(:tooth_table_pd_b_bsp5) { true }
    let(:tooth_table_pd_b_bsp6) { true }
    let(:tooth_table_pd_b_bsp7) { true }
    let(:tooth_table_pd_b_bsp8) { true }
    let(:tooth_table_pd_b_bsp9) { true }
    let(:tooth_table_pd_l1)     { 1 }
    let(:tooth_table_pd_l2)     { 2 }
    let(:tooth_table_pd_l3)     { 3 }
    let(:tooth_table_pd_l_bsp1) { true }
    let(:tooth_table_pd_l_bsp2) { true }
    let(:tooth_table_pd_l_bsp3) { true }
    let(:tooth_table_pd_l_bsp4) { true }
    let(:tooth_table_pd_l_bsp5) { true }
    let(:tooth_table_pd_l_bsp6) { true }
    let(:tooth_table_pd_l_bsp7) { true }
    let(:tooth_table_pd_l_bsp8) { true }
    let(:tooth_table_pd_l_bsp9) { true }

    let(:tooth_table_gm_b1)     { 1 }
    let(:tooth_table_gm_b2)     { 2 }
    let(:tooth_table_gm_b3)     { 3 }
    let(:tooth_table_gm_b_bsp1) { true }
    let(:tooth_table_gm_b_bsp2) { true }
    let(:tooth_table_gm_b_bsp3) { true }
    let(:tooth_table_gm_b_bsp4) { true }
    let(:tooth_table_gm_b_bsp5) { true }
    let(:tooth_table_gm_b_bsp6) { true }
    let(:tooth_table_gm_b_bsp7) { true }
    let(:tooth_table_gm_b_bsp8) { true }
    let(:tooth_table_gm_b_bsp9) { true }
    let(:tooth_table_gm_l1)     { 1 }
    let(:tooth_table_gm_l2)     { 2 }
    let(:tooth_table_gm_l3)     { 3 }
    let(:tooth_table_gm_l_bsp1) { true }
    let(:tooth_table_gm_l_bsp2) { true }
    let(:tooth_table_gm_l_bsp3) { true }
    let(:tooth_table_gm_l_bsp4) { true }
    let(:tooth_table_gm_l_bsp5) { true }
    let(:tooth_table_gm_l_bsp6) { true }
    let(:tooth_table_gm_l_bsp7) { true }
    let(:tooth_table_gm_l_bsp8) { true }
    let(:tooth_table_gm_l_bsp9) { true }

    example_request 'Get tooth' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(ToothTable.find(id)).to_json
    end
  end

  get '/patient_treatments/show_patient_perio_data_entry' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }

    parameter :auth_token,      'Authentication Token',     scope: :data,   required: true
    parameter :patient_id,      'Patient id',               scope: :data,   required: true
    parameter :field,           'mgl/cal/pd/gm',            scope: :data,   required: true

    let(:auth_token)     { provider.user.auth_token }
    let(:patient_id)     { patient.id }
    let(:field)          { 'mgl' }

    example_request 'Get full perio' do
      data = JSON.parse(response_body)['data']
      expect(status).to                        eq 200
      expect(data['patient'].present?).to      eq true
      expect(data['field'].present?).to        eq true
      expect(data['top_teeth'].present?).to    eq true
      expect(data['bottom_teeth'].present?).to eq true
    end
  end

  patch '/patient_treatments/update_tooth' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }

    parameter :auth_token,   'Authentication Token',                                    required: true
    parameter :tooth_tables, 'All 32 tooth with specific tooth field', scope: :patient, required: true

    let(:auth_token)    { provider.user.auth_token }
    let(:tooth_tables)  { patient.tooth_tables.map{ |tt| { id: tt.id,
                                                           tooth_field_id: tt.mgl.id,
                                                           tooth_field: {
                                                               b1: tt.mgl.b1,
                                                               b2: tt.mgl.b2,
                                                               b3: tt.mgl.b3,
                                                               b_bsp1: tt.mgl.b_bsp1,
                                                               b_bsp2: tt.mgl.b_bsp2,
                                                               b_bsp3: tt.mgl.b_bsp3,
                                                               b_bsp4: tt.mgl.b_bsp4,
                                                               b_bsp5: tt.mgl.b_bsp5,
                                                               b_bsp6: tt.mgl.b_bsp6,
                                                               b_bsp7: tt.mgl.b_bsp7,
                                                               b_bsp8: tt.mgl.b_bsp8,
                                                               b_bsp9: tt.mgl.b_bsp9,
                                                               l1: tt.mgl.l1,
                                                               l2: tt.mgl.l2,
                                                               l3: tt.mgl.l3,
                                                               l_bsp1: tt.mgl.l_bsp1,
                                                               l_bsp2: tt.mgl.l_bsp2,
                                                               l_bsp3: tt.mgl.l_bsp3,
                                                               l_bsp4: tt.mgl.l_bsp4,
                                                               l_bsp5: tt.mgl.l_bsp5,
                                                               l_bsp6: tt.mgl.l_bsp6,
                                                               l_bsp7: tt.mgl.l_bsp7,
                                                               l_bsp8: tt.mgl.l_bsp8,
                                                               l_bsp9: tt.mgl.l_bsp9,
                                                           }
                                                         }
                                                  }}

    example_request 'Update all teeth fields' do
      expect(status).to eq 200
    end
  end

  get '/patient_treatments/set_tooth_bsp' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }

    parameter :auth_token,    'Authentication Token',                                    scope: :data,   required: true
    parameter :field_name,    'b_bsp1, b_bsp2 ... b_bsp9 or l_bsp1, l_bsp2 ... l_bsp9',  scope: :data,   required: true
    parameter :id,            'Tooth table id',                                          scope: :data,   required: true

    let(:auth_token)  { provider.user.auth_token }
    let(:field_name)  { 'b_bsp4' }
    let(:id)          { patient.tooth_tables.first.id }

    example_request 'Inverse value of field name for tooth table and all child tooth fields' do
      expect(status).to eq 200
    end
  end
end