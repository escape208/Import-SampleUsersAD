Import-SampleUsers
======================

Overview
--------

This module generates a list of sample users and imports them into AD. This module uses the public API from ``https://randomuser.me`` to generate a majority of its sample data. Some custom data is created by this module for making it more AD-appropriate, as outlined below.

System Requirements
-------------------

* An Active Directory Domain with permissions to create OUs and Users
* PowerShell 7.0
* Internet Connection (for accessing the ``randomuser.me`` API)

Departments
-----------

Users are categorized into one of 4 departments at random:

* Marketing
* IT
* Engineering
* Sales

Each department has multiple job titles available that are randomly assigned to the user.

User Placement
--------------

The user object is placed into a parent OU of the same name as the department. For example a ``Marketing`` user will be added to the ``Marketing`` department OU. If this OU doesn't already exist, a new one is created.

All new Department OUs are created under the ``Personal Accounts`` OU, or the OU specified by the user in parameter ``-BaseOUName``. If this OU doesn't exist, a new one is created at the root of the domain.

**Default OU structure if no -BaseOUName is specified:**

.. code-block:: text
   
   OU=Personal Accounts
   |
   |-->OU=Marketing
   |  |
   |  CN=FirstUser
   |  CN=SecondUser
   |  
   |-->OU=IT
       |
       CN=ThirdUser
       CN=FourthUser
   ...

