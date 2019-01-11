Doctor Portal API - version v1.2
--------------------------------

Start project
-------------

```bash
  bash> rethinkdb --http-port 9090 --bind all
  bash> rake db:nested_models
  bash> rails s
```

Authorization
-------------

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"data":{"email":"doctor@ehr1medical.com","password":"doctor"}}' http://localhost:3000/sessions/create
```

Save ``auth_token`` that will come back! Response:

```bash
  {"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d"...}
```

> You need to save ``14896eb161ac7ce7dc4ffa2bb297bd4d``

To get all users (DON'T forget ``auth_token`` in ALL your requests):

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X GET -d '{"data":{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d"}}' http://localhost:3000/users
```

To logout:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X DELETE -d '{"data":{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d"}}' http://localhost:3000/sessions/destroy
```

To registrate new provider:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"data":{"user":{"email":"patient0@ehr1medical.com","password":"patient","password_confirmation":"patient"}, "provider":{"first_name":"Danny"}}}' http://localhost:3000/registration/create
```

To see ``current_user.provider``:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X GET -d '{"data":{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d"}}' http://localhost:3000/providers
```

PatientController
-----------------

To create patient:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"data":{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d","user":{"email":"patient0@ehr1medical.com","password":"patient","password_confirmation":"patient"}, "patient":{"first_name":"Danny"}}}' http://localhost:3000/patients
```
For DELETE
=============================

To simple create patient:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d", "patient":{"first_name":"Danny"}}' http://localhost:3000/patients/simple_create
```

AppointmentController
---------------------

To create appointment:

1. Create Referral. ``curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d", "referral":{"normal":"OK"}}' http://localhost:3000/referrals``


2. Use ``referral_id`` from prev query to create appointment. ``curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d", "appointment":{"location":"522 Ave Street", "referral_id":"2kCFc4G7YqtsAm"}}' http://localhost:3000/appointments``

To update appointment:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X PATCH -d '{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d", "appointment":{"location":"523 Ave Street", "referral_id":"2kCFc4G7YqtsAm"}, "referral":{"normal":"BADD"}}' http://localhost:3000/appointments/2kCG755aOMpLSO
```

To show appointment:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X GET -d '{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d"}' http://localhost:3000/appointments/2kCG755aOMpLSO
```

To destroy appointment:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X DELETE -d '{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d"}' http://localhost:3000/appointments/2kCG755aOMpLSO
```

BlockOutController
------------------

To create block out:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d", "block_out":{"description":"Long long description"}}' http://localhost:3000/block_outs
```

TextMessageController
---------------------

To create text message:

```bash
curl -i -H "Acceplication/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d", "To":"Long long description"}' http://localhost:3000/text_messages
```

PatientAppointmentController
----------------------------

To create patient appointment:

```bash
curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"auth_token":"14896eb161ac7ce7dc4ffa2bb297bd4d", "patient_appointment":{"location":"Long long location"}}' http://localhost:3000/patient_appointments
```

> You can take control of Apitome controller and request auhentication.
1. configure apitome to not mount itself by setting ``mount_at`` to nil
2. write your controller ApidocsController extending ``Apitome::DocsController``
3. add ``before_filter :authenticate_user!`` in your controller
4. add a route to your ``controller: get '/api/docs', to: 'apidocs#index'``

> Controller implementatin would go like this:

```ruby
  class ApidocsController < Apitome::DocsController
    before_filter :authenticate_user!
  end
```

#### 14 Mar 2016 Oleg Kapranov
