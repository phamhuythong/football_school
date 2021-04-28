####################################
#
# do things with campaign tables
#
####################################


# List of ACTIVE  campaigns
#
SELECT     id, name, description, duration, duration_type, start_date, end_date   
FROM       campaigns   WHERE  end_date > now()  ORDER BY  id;


# List of campaigns
#
SELECT     id, name, description, duration, duration_type, start_date, end_date, deleted   
FROM  campaigns   ORDER BY  id;



# Show all the ACTIVE campaigns and their messages
#
SELECT    campaigns.name, campaigns.id AS "CampaignID", emails.name, emails.template_name, emails.id as "Email ID", 
          emails.email_id as "EMAIL-ID", campaign_details.email_order, campaign_details.id as "Campaign Det ID", 
          emails.id as "Email id", interval_number, interval_type, campaign_details.email_type
FROM      campaigns, emails, campaign_details  
WHERE     campaigns.id=campaign_details.campaign_id 
          AND emails.id=campaign_details.email_id
          AND campaigns.end_date > now()
ORDER BY  campaigns.name, campaign_details.email_order;



# Show all the campaigns and their messages
#
SELECT    campaigns.name, campaigns.id AS "CampaignID", emails.name, emails.template_name, emails.id as "Email ID", 
          emails.email_id as "EMAIL-ID", campaign_details.email_order, campaign_details.id as "Campaign Det ID", 
          emails.id as "Email id", interval_number, interval_type, campaign_details.email_type
FROM      campaigns, emails, campaign_details  
WHERE     campaigns.id=campaign_details.campaign_id 
          AND  emails.id=campaign_details.email_id
ORDER BY  campaigns.name, campaign_details.email_order;




# Show all the ACTIVE campaigns and their messages AND EMAIL SUBJECTS
#
SELECT    campaigns.name, campaigns.id AS "CampaignID", emails.name, emails.template_name, emails.id as "Email ID", 
          emails.email_id as "EMAIL-ID", campaign_details.email_order, campaign_details.id as "Campaign Det ID", 
          emails.id as "Email id", interval_number, interval_type, campaign_details.email_type, emails.subject as "Subject"
FROM      campaigns, emails, campaign_details  
WHERE     campaigns.id=campaign_details.campaign_id 
          AND emails.id=campaign_details.email_id
          AND campaigns.end_date > now()
ORDER BY  campaigns.name, campaign_details.email_order;





# List the emails in a specific campaign
#
SELECT      campaigns.name as "Campaign", campaign_details.email_order as "Sequence", emails.subject as "Email subject", 
            campaign_details.interval_number as "Delta days", emails.template_name as "Email template", campaigns.start_date as "Start date",
            emails.id as "emails.id", campaign_details.id as "campaign_details id"
FROM        campaigns
LEFT JOIN   campaign_details
ON          campaigns.id=campaign_details.campaign_id  
LEFT JOIN   emails
ON          campaign_details.email_id=emails.id
WHERE       campaigns.id=4
ORDER BY    campaigns.id, campaign_details.email_order;


# List the emails in ALL ACTIVE campaigns
#
SELECT      campaigns.name as "Campaign", campaign_details.email_order as "Sequence", 
            campaign_details.description as "Camp Det Descr", emails.subject as "Email subject", 
            campaign_details.interval_number as "Delta days", emails.template_name as "Email template", campaigns.start_date as "Start date",
            emails.id as "emails.id", campaign_details.id as "campaign_details id"
FROM        campaigns
LEFT JOIN   campaign_details
ON          campaigns.id=campaign_details.campaign_id  
LEFT JOIN   emails
ON          campaign_details.email_id=emails.id
WHERE       campaigns.end_date > now()
ORDER BY    campaigns.id, campaign_details.email_order;


# Show the whole email list
#
SELECT  id, email_id, name, subject, template_name, status from emails ORDER BY id;

SELECT  id, email_id, name, subject, template_name, status from emails ORDER BY email_id;





# Show which firms are using which campaign, by campaign
#
SELECT      brands.name, partners.name, campaigns.name, practices.created_at, 
            practices.name
FROM        practices
LEFT JOIN   campaigns
ON          practices.campaign_id=campaigns.id
LEFT JOIN   brands
ON          practices.brand_id=brands.id
LEFT JOIN   partners
ON          practices.partner_id=partners.id
WHERE       practices.test=FALSE
ORDER BY    brands.name, partners.name, campaigns.name, practices.name;





# Show which firms are using which campaign, by campaign, WITH TRADES
#
SELECT      brands.name AS "Brand", partners.name AS "Partner Group", 
            campaigns.name AS "Campaign", practices.name AS "Firm", 
            trades.display_name AS "Trades", rates.name AS "Rates",
            TO_CHAR((practices.created_at AT TIME ZONE 'UT') AT TIME ZONE 'EST', 'YYYY-MM-DD') AS "Date added"
FROM        practices
LEFT JOIN   campaigns
ON          practices.campaign_id=campaigns.id
LEFT JOIN   brands
ON          practices.brand_id=brands.id
LEFT JOIN   partners
ON          practices.partner_id=partners.id
LEFT JOIN   practice_trades
ON          practices.id=practice_trades.practice_id
LEFT JOIN   trades
ON          trades.id=practice_trades.trade_id
LEFT JOIN   rates
ON          practices.ccmp_rate_id=rates.id
WHERE       practices.test=FALSE
ORDER BY    brands.name, partners.name, campaigns.name, practices.name, trades.display_name;


# Show which firms are using which campaign, by campaign, WITHOUT TRADES
#
SELECT      brands.name AS "Brand", partners.name AS "Partner Group", 
            campaigns.name AS "Campaign", practices.name AS "Firm", 
            rates.name AS "Rates",
            TO_CHAR((practices.created_at AT TIME ZONE 'UT') AT TIME ZONE 'EST', 'YYYY-MM-DD') AS "Date added"
FROM        practices
LEFT JOIN   campaigns
ON          practices.campaign_id=campaigns.id
LEFT JOIN   brands
ON          practices.brand_id=brands.id
LEFT JOIN   partners
ON          practices.partner_id=partners.id
LEFT JOIN   rates
ON          practices.ccmp_rate_id=rates.id
WHERE       practices.test=FALSE
ORDER BY    rates.name;



#
# Show trade associations and campaigns
#    NOTE:   if in more than 1 association there will be multiple lines

SELECT      campaigns.name, practices.name, trades.name
FROM        practices
LEFT JOIN   campaigns
ON          practices.campaign_id=campaigns.id
LEFT JOIN   practice_trades
ON          practices.id=practice_trades.practice_id
LEFT JOIN   trades
ON          trades.id=practice_trades.trade_id
ORDER BY    campaigns.name, practices.name;



#
# what firms have not campaign

SELECT      practices.name
FROM        practices
WHERE       practices.campaign_id IS NULL;







# List the emails in the DCS $5 for 10 2016 campaign
#
SELECT      campaigns.name as "Campaign", campaign_details.email_order as "Sequence", 
            emails.subject as "Email subject", campaign_details.interval_number as "Delta days", 
            emails.template_name as "Email template", campaigns.start_date as "Start date"
FROM        campaigns
LEFT JOIN   campaign_details
ON          campaigns.id=campaign_details.campaign_id  
LEFT JOIN   emails
ON          campaign_details.email_id=emails.id
WHERE       emails.template_name LIKE 'dcs_5%'
ORDER BY    campaigns.id, campaign_details.email_order;


##########
#
# See the status of a campaign for a user
#
##########

SELECT     practices.name, users.first_name, users.last_name, email, campaign_start_date, 
           current_email_order, campaign_detail_id
FROM       practices, users, client_details
WHERE      practices.id=users.practice_id  AND  users.id=client_details.user_id  AND
           practices.name like 'Campai%';




########
#
# Associate the DCS campaign with the all firms except PMP firm
# Associate the PMP campaign with the Protect myPlans firm
#
########

UPDATE  practices   SET  campaign_id=1 where name<>'Protect myPlans';
UPDATE  practices   SET  campaign_id=2 where name='Protect myPlans';


############
#
# setup the Smith Barid campaign
#
############

    ###
    ### DEV SERVER,  IN MINUTES
    ###
    ### 1.  create campaign
    ### 2.  add email templates
    ### 3.  add campaign details (email sequence for campaign
    ### 4.  assign the campaign to the firm
    ###

INSERT INTO campaigns (start_date, end_date, success_criteria_number, name, description, duration, duration_type, created_at, updated_at) VALUES
( '2016-09-01', '2020-12-31', 10, 'Smith Barid $10for10 2016', 'Smith Barid clients get a gift card for 10 accounts in first 60 days', 62, 'm',  now(), now() );

INSERT INTO emails ( email_id, name, subject, template_name, created_at, updated_at, status ) VALUES
( 'E.030.2', 'Smith Barid 10for10 email 1', 'An exclusive Premier member offer!',                'smith_barid_10for10_email1',  now(), now(), 'completed' ),
( 'E.031.2', 'Smith Barid 10for10 email 2', 'The enormous risks of not planning ahead!',         'smith_barid_10for10_email2',  now(), now(), 'completed' );

INSERT INTO campaign_details (campaign_id, email_id, interval_number, interval_type, email_order, email_type, name, description, created_at, updated_at )
VALUES
( 5, 75, 1,  'm', 1,  'e',  'Email1',          'Intro',               now(), now() ),
( 5, 76, 1,  'm', 2,  'e',  'Email2',          'Enormous risks',      now(), now() ),
( 5, 54, 1,  'm', 3,  'e',  'Email3',          'Privacy',             now(), now() ),
( 5, 55, 1,  'm', 4,  'e',  'Email4',          'Effortless',          now(), now() ),
( 5, 56, 1,  'm', 5,  'e',  'Email5',          'Planning',            now(), now() ),
( 5, 57, 1,  'm', 6,  'r',  'Email6',          'Reminder 1',          now(), now() ),
( 5, 58, 1,  'm', 7,  'r',  'Email7',          'Reminder 2',          now(), now() ),
( 5, 59, 1,  'm', 8,  'r',  'Email8',          'Reminder 2',          now(), now() ),
( 5, 60, 1,  'm', 10, 'c',  'Congratulations', 'Completed campaign.', now(), now() );

UPDATE practices SET campaign_id=5 WHERE name like 'Smith%';



#######################################################
#######################################################
#######################################################
#
# DELETE A CAMPAIGN
#
#######################################################
#######################################################
#######################################################

SELECT  id, name FROM  campaign_details  WHERE  campaign_id=1;

	#
	#  find all users using this campaign
	#
SELECT  first_name, last_name, practices.name  FROM  users, client_details, practices
WHERE   users.id=client_details.user_id AND users.practice_id=practices.id AND client_details.campaign_id=1;

SELECT  first_name, last_name, practices.name, client_details.campaign_detail_id  FROM  users, client_details, practices
WHERE   users.id=client_details.user_id AND users.practice_id=practices.id 
        AND client_details.campaign_detail_id<=8;

UPDATE  client_details  SET  campaign_detail_id=35 WHERE  campaign_detail_id<=8;

UPDATE  client_details  SET  campaign_id=3 WHERE  campaign_id=1;

	#
	#  delete from CAMPAIGN_DETAILS table
	#
DELETE       FROM  campaign_details  WHERE  campaign_id=1;

DELETE FROM  campaigns  WHERE  name='Campaign the first';






###### add one for remind_PP

INSERT INTO emails ( email_id, name, subject, template_name, created_at, updated_at, status ) VALUES
( 'E.022.1', 'PMP - Remind client to download PP', 'Make account capture easier - download Portfolio Plus today!',                'self_reg_client_remind_PP',  now(), now(), 'completed' );





###########
#
#  FOR TESTING, SET TO MINUTES, NOT DAYS
#
###########

# set to minutes
#   
UPDATE   campaigns         SET   duration_type='m';
UPDATE   campaign_details  SET   interval_type='m';


# set to days
#
UPDATE   campaigns         SET   duration_type='d';
UPDATE   campaign_details  SET   interval_type='d';



##############
#
# initialize the DCS and PMP $10 for 10 campaign, August 2016
#
##############


INSERT INTO campaigns (start_date, end_date, success_criteria_number, name, description, duration, duration_type, created_at, updated_at)
VALUES
( '2016-08-01', '2020-12-31', 10, 'DCS $10for10 2016', 'DCS clients get a gift card for 10 accounts in first 60 days', 62, 'd',  now(), now() ),
( '2016-08-01', '2020-12-31', 10, 'PMP $10for10 2016', 'PMP clients get a gift card for 10 accounts in first 60 days', 62, 'd',  now(), now() );

# what are the id's ?
#
SELECT     id, name, description   FROM  campaigns   ORDER BY  id;


INSERT INTO emails ( email_id, name, subject, template_name, created_at, updated_at, status )
VALUES
( 'E.030', 'DCS 10for10 email 1', 'An exclusive Premier member offer!',                'dcs_10for10_email1',  now(), now(), 'completed' ),
( 'E.031', 'DCS 10for10 email 2', 'The enormous risks of not planning ahead!',         'dcs_10for10_email2',  now(), now(), 'completed' ),
( 'E.032', 'DCS 10for10 email 3', 'Your privacy & security are our #1 priority!',      'dcs_10for10_email3',  now(), now(), 'completed' ),
( 'E.033', 'DCS 10for10 email 4', 'Effortless planning with huge benefits!',           'dcs_10for10_email4',  now(), now(), 'completed' ),
( 'E.034', 'DCS 10for10 email 5', 'Planning is your responsibility!',                  'dcs_10for10_email5',  now(), now(), 'completed' ),
( 'E.035', 'DCS 10for10 email 6', 'Add 10 accounts today, get a $10 gift card!',       'dcs_10for10_email6',  now(), now(), 'completed' ),
( 'E.036', 'DCS 10for10 email 7', 'Time is running out - get your $10 gift card now!', 'dcs_10for10_email7',  now(), now(), 'completed' ),
( 'E.037', 'DCS 10for10 email 8', 'Exclusive $10 gift card offer expires in 1 day!',   'dcs_10for10_email8',  now(), now(), 'completed' ),
( 'E.039', 'DCS 10for10 email 10', 'Choose your gift card!',                           'dcs_10for10_email10', now(), now(), 'completed' ),

( 'E.040', 'PMP 10for10 email 1', 'An exclusive Premier member offer!',                'pmp_10for10_email1',  now(), now(), 'completed' ),
( 'E.041', 'PMP 10for10 email 2', 'The enormous risks of not planning ahead!',         'pmp_10for10_email2',  now(), now(), 'completed' ),
( 'E.042', 'PMP 10for10 email 3', 'Your privacy & security are our #1 priority!',      'pmp_10for10_email3',  now(), now(), 'completed' ),
( 'E.043', 'PMP 10for10 email 4', 'Effortless planning with huge benefits!',           'pmp_10for10_email4',  now(), now(), 'completed' ),
( 'E.044', 'PMP 10for10 email 5', 'Planning is your responsibility!',                  'pmp_10for10_email5',  now(), now(), 'completed' ),
( 'E.045', 'PMP 10for10 email 6', 'Add 10 accounts today, get a $10 gift card!',       'pmp_10for10_email6',  now(), now(), 'completed' ),
( 'E.046', 'PMP 10for10 email 7', 'Time is running out - get your $10 gift card now!', 'pmp_10for10_email7',  now(), now(), 'completed' ),
( 'E.047', 'PMP 10for10 email 8', 'Exclusive $10 gift card offer expires in 1 day!',   'pmp_10for10_email8',  now(), now(), 'completed' ),
( 'E.049', 'PMP 10for10 email 10', 'Choose your gift card!',                           'pmp_10for10_email10', now(), now(), 'completed' );


# GET THE CORRECT EMAIL_ID VALUES, FOR COLUMN 2
#
SELECT    name, id, created_at   FROM  emails  WHERE name  LIKE  '%10for10%'  ORDER BY id;



INSERT INTO campaign_details (campaign_id, email_id, interval_number, interval_type, email_order, email_type, name, description, created_at, updated_at )
VALUES
( ww, xx, 2,  'd', 1,  'e',  'Email1',          'Intro',               now(), now() ),
( ww, xx, 3,  'd', 2,  'e',  'Email2',          'Enormous risks',      now(), now() ),
( ww, xx, 3,  'd', 3,  'e',  'Email3',          'Privacy',             now(), now() ),
( ww, xx, 3,  'd', 4,  'e',  'Email4',          'Effortless',          now(), now() ),
( ww, xx, 3,  'd', 5,  'e',  'Email5',          'Planning',            now(), now() ),
( ww, xx, 18, 'd', 6,  'r',  'Email6',          'Reminder 1',          now(), now() ),
( ww, xx, 15, 'd', 7,  'r',  'Email7',          'Reminder 2',          now(), now() ),
( ww, xx, 14, 'd', 8,  'r',  'Email8',          'Reminder 2',          now(), now() ),
( ww, xx, 62, 'd', 10, 'c',  'Congratulations', 'Completed campaign.', now(), now() ),

( ww, xx, 2,  'd', 1,  'e',  'Email1',          'Intro',               now(), now() ),
( ww, xx, 3,  'd', 2,  'e',  'Email2',          'Enormous risks',      now(), now() ),
( ww, xx, 3,  'd', 3,  'e',  'Email3',          'Privacy',             now(), now() ),
( ww, xx, 3,  'd', 4,  'e',  'Email4',          'Effortless',          now(), now() ),
( ww, xx, 3,  'd', 5,  'e',  'Email5',          'Planning',            now(), now() ),
( ww, xx, 18, 'd', 6,  'r',  'Email6',          'Reminder 1',          now(), now() ),
( ww, xx, 15, 'd', 7,  'r',  'Email7',          'Reminder 2',          now(), now() ),
( ww, xx, 14, 'd', 8,  'r',  'Email8',          'Reminder 2',          now(), now() ),
( ww, xx, 62, 'd', 10, 'c',  'Congratulations', 'Completed campaign.', now(), now() );



#
#
#
SELECT    id, campaign_id, email_id, interval_number, interval_type, email_order, name, email_type 
FROM      campaign_details 
ORDER BY  email_order;





===================================================================

OLD STUFF


############################################################
#
# Setup DEMO server for rapid testing of DCS messages
#
############################################################

INSERT INTO campaigns (start_date, end_date, success_criteria_number, name, description, duration, duration_type, created_at, updated_at) VALUES
( '2016-09-01', '2020-12-31', 10, 'Test DCS 2016-09', 'Testing DCS 10for10 email', 62, 'm',  now(), now() ),
( '2016-09-01', '2020-12-31', 10, 'Test PMP 2016-09', 'Testing PMP 10for10 email', 62, 'm',  now(), now() );

INSERT INTO campaign_details (campaign_id, email_id, interval_number, interval_type, email_order, email_type, name, description, created_at, updated_at )
VALUES
( 3, 32, 1,  'm', 1,  'e',  'Email1',          'Intro',               now(), now() ),
( 3, 33, 1,  'm', 2,  'e',  'Email2',          'Enormous risks',      now(), now() ),
( 3, 34, 1,  'm', 3,  'e',  'Email3',          'Privacy',             now(), now() ),
( 3, 35, 1,  'm', 4,  'e',  'Email4',          'Effortless',          now(), now() ),
( 3, 36, 1,  'm', 5,  'e',  'Email5',          'Planning',            now(), now() ),
( 3, 37, 1,  'm', 6,  'r',  'Email6',          'Reminder 1',          now(), now() ),
( 3, 38, 1,  'm', 7,  'r',  'Email7',          'Reminder 2',          now(), now() ),
( 3, 39, 1,  'm', 8,  'r',  'Email8',          'Reminder 2',          now(), now() ),
( 3, 40, 1,  'm', 10, 'c',  'Congratulations', 'Completed campaign.', now(), now() ),
( 4, 41, 1,  'm', 1,  'e',  'Email1',          'Intro',               now(), now() ),
( 4, 42, 1,  'm', 2,  'e',  'Email2',          'Enormous risks',      now(), now() ),
( 4, 43, 1,  'm', 3,  'e',  'Email3',          'Privacy',             now(), now() ),
( 4, 44, 1,  'm', 4,  'e',  'Email4',          'Effortless',          now(), now() ),
( 4, 45, 1,  'm', 5,  'e',  'Email5',          'Planning',            now(), now() ),
( 4, 46, 1,  'm', 6,  'r',  'Email6',          'Reminder 1',          now(), now() ),
( 4, 47, 1,  'm', 7,  'r',  'Email7',          'Reminder 2',          now(), now() ),
( 4, 48, 1,  'm', 8,  'r',  'Email8',          'Reminder 2',          now(), now() ),
( 4, 49, 1,  'm', 10, 'c',  'Congratulations', 'Completed campaign.', now(), now() );

UPDATE practices SET campaign_id=3 WHERE name='DCS';



##############
#
# initialize the DCS and PMP $10 for 10 campaign, August 2016
#
##############


INSERT INTO campaigns (start_date, end_date, success_criteria_number, name, description, duration, duration_type, created_at, updated_at)
VALUES
( '2016-08-01', '2020-12-31', 10, 'DCS $10for10 2016', 'DCS clients get a gift card for 10 accounts in first 60 days', 62, 'd',  now(), now() ),
( '2016-08-01', '2020-12-31', 10, 'PMP $10for10 2016', 'PMP clients get a gift card for 10 accounts in first 60 days', 62, 'd',  now(), now() );

# what are the id's ?
#
SELECT     id, name, description   FROM  campaigns   ORDER BY  id;


INSERT INTO emails ( email_id, name, subject, template_name, created_at, updated_at, status )
VALUES
( 'E.030', 'DCS 10for10 email 1', 'An exclusive Premier member offer!',                'dcs_10for10_email1',  now(), now(), 'completed' ),
( 'E.031', 'DCS 10for10 email 2', 'The enormous risks of not planning ahead!',         'dcs_10for10_email2',  now(), now(), 'completed' ),
( 'E.032', 'DCS 10for10 email 3', 'Your privacy & security are our #1 priority!',      'dcs_10for10_email3',  now(), now(), 'completed' ),
( 'E.033', 'DCS 10for10 email 4', 'Effortless planning with huge benefits!',           'dcs_10for10_email4',  now(), now(), 'completed' ),
( 'E.034', 'DCS 10for10 email 5', 'Planning is your responsibility!',                  'dcs_10for10_email5',  now(), now(), 'completed' ),
( 'E.035', 'DCS 10for10 email 6', 'Add 10 accounts today, get a $10 gift card!',       'dcs_10for10_email6',  now(), now(), 'completed' ),
( 'E.036', 'DCS 10for10 email 7', 'Time is running out - get your $10 gift card now!', 'dcs_10for10_email7',  now(), now(), 'completed' ),
( 'E.037', 'DCS 10for10 email 8', 'Exclusive $10 gift card offer expires in 1 day!',   'dcs_10for10_email8',  now(), now(), 'completed' ),
( 'E.039', 'DCS 10for10 email 10', 'Choose your gift card!',                           'dcs_10for10_email10', now(), now(), 'completed' ),

( 'E.040', 'PMP 10for10 email 1', 'An exclusive Premier member offer!',                'pmp_10for10_email1',  now(), now(), 'completed' ),
( 'E.041', 'PMP 10for10 email 2', 'The enormous risks of not planning ahead!',         'pmp_10for10_email2',  now(), now(), 'completed' ),
( 'E.042', 'PMP 10for10 email 3', 'Your privacy & security are our #1 priority!',      'pmp_10for10_email3',  now(), now(), 'completed' ),
( 'E.043', 'PMP 10for10 email 4', 'Effortless planning with huge benefits!',           'pmp_10for10_email4',  now(), now(), 'completed' ),
( 'E.044', 'PMP 10for10 email 5', 'Planning is your responsibility!',                  'pmp_10for10_email5',  now(), now(), 'completed' ),
( 'E.045', 'PMP 10for10 email 6', 'Add 10 accounts today, get a $10 gift card!',       'pmp_10for10_email6',  now(), now(), 'completed' ),
( 'E.046', 'PMP 10for10 email 7', 'Time is running out - get your $10 gift card now!', 'pmp_10for10_email7',  now(), now(), 'completed' ),
( 'E.047', 'PMP 10for10 email 8', 'Exclusive $10 gift card offer expires in 1 day!',   'pmp_10for10_email8',  now(), now(), 'completed' ),
( 'E.049', 'PMP 10for10 email 10', 'Choose your gift card!',                           'pmp_10for10_email10', now(), now(), 'completed' );


# GET THE CORRECT EMAIL_ID VALUES, FOR COLUMN 2
#
SELECT    name, id, created_at   FROM  emails  WHERE name  LIKE  '%10for10%'  ORDER BY id;



INSERT INTO campaign_details (campaign_id, email_id, interval_number, interval_type, email_order, email_type, name, description, created_at, updated_at )
VALUES
( ww, xx, 2,  'd', 1,  'e',  'Email1',          'Intro',               now(), now() ),
( ww, xx, 3,  'd', 2,  'e',  'Email2',          'Enormous risks',      now(), now() ),
( ww, xx, 3,  'd', 3,  'e',  'Email3',          'Privacy',             now(), now() ),
( ww, xx, 3,  'd', 4,  'e',  'Email4',          'Effortless',          now(), now() ),
( ww, xx, 3,  'd', 5,  'e',  'Email5',          'Planning',            now(), now() ),
( ww, xx, 18, 'd', 6,  'r',  'Email6',          'Reminder 1',          now(), now() ),
( ww, xx, 15, 'd', 7,  'r',  'Email7',          'Reminder 2',          now(), now() ),
( ww, xx, 14, 'd', 8,  'r',  'Email8',          'Reminder 2',          now(), now() ),
( ww, xx, 62, 'd', 10, 'c',  'Congratulations', 'Completed campaign.', now(), now() ),

( ww, xx, 2,  'd', 1,  'e',  'Email1',          'Intro',               now(), now() ),
( ww, xx, 3,  'd', 2,  'e',  'Email2',          'Enormous risks',      now(), now() ),
( ww, xx, 3,  'd', 3,  'e',  'Email3',          'Privacy',             now(), now() ),
( ww, xx, 3,  'd', 4,  'e',  'Email4',          'Effortless',          now(), now() ),
( ww, xx, 3,  'd', 5,  'e',  'Email5',          'Planning',            now(), now() ),
( ww, xx, 18, 'd', 6,  'r',  'Email6',          'Reminder 1',          now(), now() ),
( ww, xx, 15, 'd', 7,  'r',  'Email7',          'Reminder 2',          now(), now() ),
( ww, xx, 14, 'd', 8,  'r',  'Email8',          'Reminder 2',          now(), now() ),
( ww, xx, 62, 'd', 10, 'c',  'Congratulations', 'Completed campaign.', now(), now() );



#
#
#
SELECT    id, campaign_id, email_id, interval_number, interval_type, email_order, name, email_type 
FROM      campaign_details 
ORDER BY  email_order;





#
# List the emails in the DCS $10 for 10 2016 campaign

SELECT      campaigns.name as "Campaign", campaign_details.email_order as "Sequence", emails.subject as "Email subject", 
            campaign_details.interval_number as "Delta days", emails.template_name as "Email template", campaigns.start_date as "Start date"
FROM        campaigns
LEFT JOIN   campaign_details
ON          campaigns.id=campaign_details.campaign_id  
LEFT JOIN   emails
ON          campaign_details.email_id=emails.id
ORDER BY    campaigns.id, campaign_details.email_order;




################################################
#
# update the timing on the campaigns
#
################################################

SELECT    campaigns.name, campaign_details.id as "CampDetail ID", emails.name, emails.template_name, 
          emails.id as "Email ID", emails.email_id as "Email EMAIL ID", campaign_details.email_order, 
          interval_number, campaign_details.id, interval_type, campaign_details.email_type
FROM      campaigns, emails, campaign_details  
WHERE     campaigns.id=campaign_details.campaign_id AND 
          emails.id=campaign_details.email_id
          AND campaigns.name not like 'Test%'
ORDER BY  campaigns.name, campaign_details.email_order;


UPDATE  campaign_details  SET  interval_number=2   WHERE  id=1;
UPDATE  campaign_details  SET  interval_number=3   WHERE  id=2;
UPDATE  campaign_details  SET  interval_number=3   WHERE  id=3;
UPDATE  campaign_details  SET  interval_number=3   WHERE  id=4;
UPDATE  campaign_details  SET  interval_number=3   WHERE  id=5;
UPDATE  campaign_details  SET  interval_number=15  WHERE  id=6;
UPDATE  campaign_details  SET  interval_number=15  WHERE  id=7;
UPDATE  campaign_details  SET  interval_number=14  WHERE  id=8;

UPDATE  campaign_details  SET  interval_number=2   WHERE  id=10;
UPDATE  campaign_details  SET  interval_number=3   WHERE  id=11;
UPDATE  campaign_details  SET  interval_number=3   WHERE  id=12;
UPDATE  campaign_details  SET  interval_number=3   WHERE  id=13;
UPDATE  campaign_details  SET  interval_number=3   WHERE  id=14;
UPDATE  campaign_details  SET  interval_number=15  WHERE  id=15;
UPDATE  campaign_details  SET  interval_number=15  WHERE  id=16;
UPDATE  campaign_details  SET  interval_number=14  WHERE  id=17;


