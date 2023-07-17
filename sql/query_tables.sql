USE pro_buddy;

SELECT * FROM users_user;
SELECT * FROM users_user_groups; 
SELECT * FROM users_user_user_permissions;
SELECT * FROM users_userchat;
SELECT * FROM users_userinterest;
SELECT * FROM users_userservice;

SELECT * FROM buddies_buddy;
-- DELETE FROM buddies_buddygroup WHERE id < 7;
SELECT * FROM buddies_buddygroup;
SELECT * FROM buddies_buddygroupevent; 
SELECT * FROM buddies_buddygroupeventmember;
SELECT * FROM buddies_buddygroupmember;
SELECT * FROM buddies_buddygroupeventreview;