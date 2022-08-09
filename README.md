# pos-tracker-dashboard

Flutter web app intended for Admins who are resposible for looking after the pos machines. The app tracks the pos-tracker app, which sends its location information and status in realtime to a firestore database.
 
It also enables admins to view every information of each terminal. There are four types of users:

#1 Head-office admins
- Can View all terminals under all districts
- Have all available privileges: editing, archiving and relocating
- user management: adding, updating, and deactivating (deleting)
- 

#2 District admins
- Can view all terminals under their district
- Reporting exceptional issues to the head-office admins
- manage/add users under their district

#3 Branch admins
- Can view all terminals under their branch
- Requesting editing, archiving, and relocating of terminals

#4 Guest users
- Intended for higher officials of the bank willing to oversee the perfomance of these terminals
- have an interactive user interface with the analysis of the overall perfomance of the terminals
- They don't have any privilege other than viewing

#NB:
As the app is under development you may not find some of the functionalities listed above, or you may find it less than expected.
