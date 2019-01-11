EHR Doctor Portal Release v1.2
==============================

Ruby on Rails
-------------
This application requires:
- Ruby  2.3.0
- Rails 4.2.5.2
- RethinkDB 2.2.5

Getting Started
---------------

Documentation and Support
-------------------------

Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------

# Phone numbers are validated for correct area codes

201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 212, 213, 214, 215, 216, 217, 218, 219, 224, 225, 226, 228, 229, 231, 234, 239, 240, 242, 246, 248, 250, 251, 252, 253, 254, 256, 260, 262, 264, 267, 268, 269, 270, 276, 281, 284, 289, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 323, 325, 330, 331, 334, 336, 337, 339, 340, 343, 345, 347, 351, 352, 360, 361, 385, 386, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 412, 413, 414, 415, 416, 417, 418, 419, 423, 424, 425, 430, 432, 434, 435, 438, 440, 441, 442, 443, 450, 456, 458, 469, 470, 473, 475, 478, 479, 480, 484, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 512, 513, 514, 515, 516, 517, 518, 519, 520, 530, 533, 534, 540, 541, 551, 559, 561, 562, 563, 567, 570, 571, 573, 574, 575, 579, 580, 581, 585, 586, 587, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 612, 613, 614, 615, 616, 617, 618, 619, 620, 623, 626, 630, 631, 636, 641, 646, 647, 649, 650, 651, 657, 660, 661, 662, 664, 670, 671, 678, 681, 682, 684, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 712, 713, 714, 715, 716, 717, 718, 719, 720, 724, 727, 731, 732, 734, 740, 747, 754, 757, 758, 760, 762, 763, 765, 767, 769, 770, 772, 773, 774, 775, 778, 779, 780, 781, 784, 785, 786, 787, 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 812, 813, 814, 815, 816, 817, 818, 819, 828, 829, 830, 831, 832, 843, 845, 847, 848, 849, 850, 855, 856, 857, 858, 859, 860, 862, 863, 864, 865, 866, 867, 868, 869, 870, 872, 876, 877, 878, 888, 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 912, 913, 914, 915, 916, 917, 918, 919, 920, 925, 928, 931, 936, 937, 938, 939, 940, 941, 947, 949, 951, 952, 954, 956, 970, 971, 972, 973, 978, 979, 980, 985, 989

# The Manufactures - http://www.cdc.gov/vaccines/about/terms/USVaccines.html
Acambis

Barr Labs Inc.

bioCSL

Emergent BioSolutions

GlaxoSmithKline

Massachusetts Biological Labs

Medimmune

Merck

Novartis

PaxVax

Protein Sciences

sanofi

Valneva

Wyeth / Pfizer

# The specific pharmacies

Model => dosespot_pharmacy

pharmacy_id:integer           required(yes) => Heplful to locate pharmacy quickly
store_name:string(500)        required(yes) => Name of the Store
address_1:string(35)          required(yes) => Pharmacy's Street Address - Line One (i.e. 539 Main Street)
address_2:string(35)          required(no)  => Pharmacy's Street Address - Line Two (i.e. Suite #2043)
city:string(35)               required(yes) => Pharmacy's City
state:string(20)              required(yes) => Pharmacy's State
zip_code:integer(10)          required(yes) => Pharmacy's Zip Code
primary_phone:string(25)      required(yes) => Primary Phone
primary_phone_type:string(35) required(yes) => Pharmacy's default phone's type
primary_fax:string(25)        required(yes) => Primary fax

Model => dosespot_patient

patient_id:integer            required(no)  =>  Require for existing patients already in DoseSpot system
                                                Not require for patients that aren't in the DoseSpot system
prefix:string(10)             required(no)  =>  Patient's Name Prefix (such as Mr.)
first_name:string(35)         required(yes) =>  patient's First Name (such as Maria)
middle_name:string(35)        required(no)  =>  patient's Middle Name
last_name:string(35)          required(yes) =>  Patient's Last Name (such as Garcia)
suffix:string(10)             required(10)  =>  Patient's suffix (such as Jr. or III)

See example table:

-------------------------------------------------------------------
Pharmacy ID:  Store Name:           City:         State:  Zip:
-------------------------------------------------------------------
7917          Ralph's Pharmacy      Indianapolis  IN      46201
7918          Smart Pharmacy        Cleveland     OH      44102
7919          Handy's Pharmacy      Philadelphia  PA      19103
7920          Schneider's Grocery   Bethesda      MD      20814
7921          Druglix               Minneapolis   MN      55401
7922          Englewood Pharmacy    Chattanooga   TN      37401
7923          Script Drug 4.20      Erie          PA      16563
7924          Drug Mart Xerox       Fort Myers    HI      967201234
-------------------------------------------------------------------

# Emergancy access issues - Sergey Troyatsky

1. During emergency access user must be able to perform actions which
   cannot be performed unless authorized for emergency access. I changed
   "Dentist" not to be able to "Add new patient" to the system and upon
   granting "Emergency Access" permission "Add new patient" did not
   appear. If user is granted "Emergency Access" he must get admin privileges

2. Emergency Access must disable itself upon login off. So when I
   granted a, for example, Maria emergency access she must have it only
   for one-time use. When she will log off and login in again she must
   not have emergency access.

# CHECK IT OUT VALIDATIONS:

1. Create and implement Single Sign On

   Generate and insert your ClinicID, ClinicianID (aka UserID),
   SingleSignOnCode and SingleSignOnUserIdVerify into the url below.
   Then copy and paste into your web browser.

   If you receive a Single Sign On error you have not generated
   the Single Sign On values correctly. If you are able to view
   the DoseSpot page entitled "Refill Requests and Transmission
   Errors" you have successfully completed this milestone!

   http://my.staging.dosespot.com/LoginSingleSignOn.aspx?b=2&SingleSignOnClinicId=551&SingleSignOnUserId=970&SingleSignOnPhraseLength=32&SingleSignOnCode=bvpUxdHGoUldEH6qpyL9Zds65WE3w1rbERvL5wGOfxuVAr1cZ/F9tsqbXQ01/LIPmkFVZfx73UeySPNsJEJNVxjAK2UHwV5wa9jjLsWw9yMuyOVjHiQZhQ&SingleSignOnUserIdVerify=m+BD71nc4c6X2MdbVDSWHiYgedX2pkv5obNMCWy703Gfx9N1Tlf74I6YEg60O9GedbBdA/MATEH0w78YJs6z+g&RefillsErrors=1

2. Please make sure that Patient First name field in patient
   Chart/Profile follows the following validations rules:

   * Requirement: Field is required and must be filled out.
   * Character Limit: 35 characters
   * Special Characters: Must support special characters including,
     !"#$%&'()*+,-/:;<=>?@[]^_`{|}

3. Please make sure that Patient Middle name field in patient
   Chart/Profile follows the following validations rules:

   * Requirement: Field is required but does not have to be filled out.
     If the field is filled out the data must be passed into DoseSpot.

   * Character Limit: 35 characters
   * Special Characters: Must support special characters including,
     !"#$%&'()*+,-/:;<=>?@[]^_`{|}

4. Please make sure that Patient Last name field in patient
   Chart/Profile follows the following validations rules:

   * Requirement: Field is required and must be filled out.
   * Character Limit: 35 characters
   * Special Characters: Must support special characters including,
     !"#$%&'()*+,-/:;<=>?@[]^_`{|}

5. Please make sure that Patient date of birth field in patient
   Chart/Profile follows the following validations rules:

   * Requirement: Field is required and must be filled out.
   * Characters: Must be a valid date and must be on or before
     today's date.

6. Please make sure that Patient Gender field in patient Chart/Profile
   follows the following validations rules:

   * Requirement: Field is required and must be filled out.
   * Characters: Must either be "Male" or "Female"
     (If necessary, "Unknown")

7. Please make sure that Patient Address - Line 1 field in patient
   Chart/Profile follows the following validations rules:

   * Requirement: Field is required and must be filled out.
   * Character Limit: 35 characters
   * Special Characters: Must support special characters including,
     !"#$%&'()*+,-/:;<=>?@[]^_` {|}

8. Please make sure that Patient Address - Line 2 field in patient
   Chart/Profile follows the following validations rules:

   * Requirement: Field is required but does not have to be filled out.
     If the field is filled out the data must be passed into DoseSpot.
   * Character Limit: 35 characters
   * Special Characters: Must support special characters including,
     !"#$%&'()*+,-/:;<=>?@[]^_` {|}

9. Please make sure that Patient Area Code field in patient
   Chart/Profile follows the following validations rules:

   * Requirement: Field is required and must be filled out.
   * Characters: Must be formatted for the United States with 3 digit
     area code & then 7 digits. Extensions are allowed by using an x
     before them.Must be able to take an extension (using an x), such
     as – (617) 874-4545 x118.

10. Generate query string (inclusive of Single Sign On credentials and
    patient demographic information) and execute the HTTP Post to create
    a new patient in DoseSpot.

    Please follow API Guide: Sections 1.2, 2.9, 3.1, 3.2, 6.1 & 6.2 - for
    more information;

    * Create your query string inclusive of your ClinicID, ClinicianID
      (aka UserID), SingleSignOnCode, SingleSignOnUserIdVerify, and
      Patient Demographics.

    * Execute a HTTP Post.

      If you receive a Single Sign On error you have not generated
      the Query String correctly (Tip: Make sure you are URL encoding
      the SingleSignOnCode, SingleSignOnUserIdVerify, and Patient
      Demographics). If you are able to view the DoseSpot Patient
      Details page you have successfully completed this milestone!

### 14 Mar 2016 Oleg G.Kapranov
