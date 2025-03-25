@tool @tool_skills @skilladdon @skilladdon_progress_block
Feature: User progress bar to the modules based user earned skills points
    In order to use the features
    As admin
    I need to be able to configure the dash plugin

    Enable the Skills total points and Progress bar per skill in dash block on the dashboard page and view it's contents
    In order to enable the Skills total points and Progress bar per skill in dash block on the dashboard
    As an admin
    I can add the dash block to the dashboard

  Background:
    Given the following "categories" exist:
        | name  | category | idnumber |
        | Cat 1 | 0        | CAT1     |
    And the following "course" exist:
        | fullname | shortname | category | enablecompletion |
        | Course 1 | C1        | 0        | 1                |
        | Course 2 | C2        | 0        | 1                |
        | Course 3 | C3        | 0        | 1                |
    And the following "activities" exist:
        | activity | name       | course | idnumber | intro            | section | completion |
        | page     | Test page1 | C1     | page1    | Page description | 1       | 1          |
        | page     | Test page2 | C2     | page1    | Page description | 2       | 1          |
        | page     | Test page3 | C3     | page1    | Page description | 3       | 1          |
    And the following "users" exist:
        | username | firstname | lastname | email                |
        | student1 | Student   | First    | student1@example.com |
        | student2 | Student   | Two      | student2@example.com |
        | student3 | Student   | Three    | student3@example.com |
    And the following "course enrolments" exist:
        | user     | course | role    | timestart | timeend |
        | student1 | C1     | student | 0         | 0       |
        | student1 | C2     | student | 0         | 0       |
        | student1 | C3     | student | 0         | 0       |
        | student2 | C2     | student | 0         | 0       |
        | student2 | C3     | student | 0         | 0       |
        | admin    | C1     | manager | 0         | 0       |
        | admin    | C2     | manager | 0         | 0       |
    And I log in as "admin"
    And I am on "Course 1" course homepage
    And I navigate to "Course completion" in current page administration
    And I expand all fieldsets
    And I set the field "Test page1" to "1"
    And I press "Save changes"
    And I am on "Course 2" course homepage
    And I navigate to "Course completion" in current page administration
    And I expand all fieldsets
    And I set the field "Test page2" to "1"
    And I press "Save changes"
    And I create skill with the following fields to these values:
        | Skill name       | Beginner |
        | Key              | beginner |
        | Number of levels | 2        |
        | Base level name    | beginner |
        | Base level point   | 10       |
        | Level #1 name    | Level 1  |
        | Level #1 point   | 20       |
        | Level #2 name    | Level 2  |
        | Level #2 point   | 30       |
    And I create skill with the following fields to these values:
        | Skill name       | Competence |
        | Key              | competence |
        | Number of levels | 2          |
        | Base level name    | beginner |
        | Base level point   | 10       |
        | Level #1 name    | Level 1    |
        | Level #1 point   | 30         |
        | Level #2 name    | Level 2    |
        | Level #2 point   | 40         |
    And I log out

  @javascript
  Scenario: Show the donut progress bar for the total skill points
    Given I log in as "admin"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I add the "Dash" block
    And I click on "Skill progress" "radio"
    And I configure the "New Dash" block
    And I set the field "Block title" to "Skill progress"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I log out
    And I log in as "admin"
    And I navigate to "Course 1" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 45      |
    And I press "Save changes"
    Then I should see "Points - 45" in the "beginner" "table_row"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Donut')]//input[@type='checkbox']" to "1"
    And I press "Save changes"
    And I should see "0" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 70" in the ".skill-total-info .total-points" "css_element"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I am on the "Course 1" course page logged in as student1
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)"
    And I am on "Course 1" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 45)"
    And I am on the "Course 1" course page logged in as student1
    And I follow "Dashboard"
    And I should see " 45 " in the ".skill-total-info .earned" "css_element"
    And I should see "/ 70" in the ".skill-total-info .total-points" "css_element"
    Then I log out

  @javascript
  Scenario: Show the user's current skill level
    Given I log in as "admin"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I add the "Dash" block
    And I click on "Skill progress" "radio"
    And I configure the "New Dash" block
    And I set the field "Block title" to "Skill progress"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I log out
    And I log in as "admin"
    And I navigate to "Course 1" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 25      |
    And I press "Save changes"
    Then I should see "Points - 25" in the "beginner" "table_row"
    And I navigate to "Course 2" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 10      |
    And I press "Save changes"
    Then I should see "Points - 10" in the "beginner" "table_row"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Current level')]//input[@type='checkbox']" to "1"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I am on the "Course 1" course page logged in as student1
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)"
    And I am on "Course 1" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 25)"
    And I follow "Dashboard"
    And I should see "Level 1" in the ".skill-user-level .current-level-name" "css_element"
    And I am on "Course 2" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 35)"
    And I follow "Dashboard"
    And I should see "Level 2" in the ".skill-user-level .current-level-name" "css_element"
    Then I log out

  @javascript
  Scenario: Show the points required to attain the next level of the skill
    Given I log in as "admin"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I add the "Dash" block
    And I click on "Skill progress" "radio"
    And I configure the "New Dash" block
    And I set the field "Block title" to "Skill progress"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I log out
    And I log in as "admin"
    And I navigate to "Course 1" course skills
    And I click on ".skill-course-actions .action-edit" "css_element" in the "beginner" "table_row"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 10      |
    And I press "Save changes"
    Then I should see "Points - 10" in the "beginner" "table_row"
    And I navigate to "Course 2" course skills
    And I click on ".skill-course-actions .action-edit" "css_element" in the "beginner" "table_row"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 10      |
    And I press "Save changes"
    Then I should see "Points - 10" in the "beginner" "table_row"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Next level points')]//input[@type='checkbox']" to "1"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I should see "10 points to become beginner" in the ".next-level-info .info-str span" "css_element"
    And I am on the "Course 1" course page
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)"
    And I am on "Course 1" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 10)"
    And I am on the "Course 1" course page logged in as student1
    And I follow "Dashboard"
    And I should see "10" in the ".skill-points-info .points-info-box .earned" "css_element"
    And I should see "/ 30" in the ".skill-points-info .points-info-box .total-points" "css_element"
    And I should see "10 points to become Level 1" in the ".next-level-info .info-str span" "css_element"
    And I am on "Course 2" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 10)"
    And I follow "Dashboard"
    And I should see "20" in the ".skill-points-info .points-info-box .earned" "css_element"
    And I should see "/ 30" in the ".skill-points-info .points-info-box .total-points" "css_element"
    And I should see "10 points to become Level 2" in the ".next-level-info .info-str span" "css_element"
    Then I log out

  @javascript
  Scenario: Show skill options & Hide the user skills
    Given I log in as "admin"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I add the "Dash" block
    And I click on "Skill progress" "radio"
    And I configure the "New Dash" block
    And I set the field "Block title" to "Skill progress"
    And I press "Save changes"
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Donut')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Current level')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Next level points')]//input[@type='checkbox']" to "1"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I should see "0" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 70" in the ".skill-total-info .total-points" "css_element"
    And I should see "10 points to become beginner" in the ".next-level-info .info-str span" "css_element"
    And I log out
    And I log in as "admin"
    And I navigate to "Course 1" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 20      |
    And I press "Save changes"
    Then I should see "Points - 20" in the "beginner" "table_row"
    And I log out
    And I am on the "Course 1" course page logged in as student1
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)"
    And I follow "Dashboard"
    And I am on "Course 1" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 20)"
    And I am on the "Course 1" course page logged in as student1
    And I follow "Dashboard"
    And I should see "20" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 70" in the ".skill-total-info .total-points" "css_element"
    And I should see "10 points to become Level 2" in the ".next-level-info .info-str span" "css_element"
    Then I log out
    And I log in as "admin"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Hide individual skills')]//input[@type='checkbox']" to "1"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I should see "20" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 70" in the ".skill-total-info .total-points" "css_element"

  #condition
  @javascript
  Scenario: Hide the user's completed skill
    Given I log in as "admin"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I add the "Dash" block
    And I click on "Skill progress" "radio"
    And I configure the "New Dash" block
    And I set the field "Block title" to "Skill progress"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I log out
    And I log in as "admin"
    And I navigate to "Course 1" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 45      |
    And I press "Save changes"
    Then I should see "Points - 45" in the "beginner" "table_row"
    And I navigate to "Course 2" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 77      |
    And I press "Save changes"
    Then I should see "Points - 77" in the "beginner" "table_row"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Donut')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Current level')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Next level points')]//input[@type='checkbox']" to "1"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I should see "0" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 70" in the ".skill-total-info .total-points" "css_element"
    And I should see "10 points to become beginner" in the ".next-level-info .info-str span" "css_element"
    And I am on the "Course 1" course page
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)"
    And I am on "Course 1" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 45)"
    And I follow "Dashboard"
    And I should see "Completed" in the ".points-info-box .skill-completed" "css_element"
    And I am on "Course 2" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 77)"
    And I follow "Dashboard"
    And I should see "Completed" in the ".points-info-box .skill-completed" "css_element"
    Then I log out
    And I log in as "admin"
    And I follow "Dashboard"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Conditions" "link" in the "Edit preferences" "dialogue"
    Then I should see "Limit data to" in the "Edit preferences" "dialogue"
    And I set the following fields to these values:
        | Hide completed skills | 1 |
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    Then I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I should see "0" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 40" in the ".skill-total-info .total-points" "css_element"
    And I should see "Competence" in the ".skill-basic-info .skill-name" "css_element"
    And I should see "10 points to become beginner" in the ".next-level-info .info-str span" "css_element"
    Then I log out

  @javascript
  Scenario: Change the user skill
    Given I log in as "admin"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I add the "Dash" block
    And I click on "Skill progress" "radio"
    And I configure the "New Dash" block
    And I set the field "Block title" to "Skill progress"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I log out
    And I log in as "admin"
    And I navigate to "Course 1" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 45      |
    And I press "Save changes"
    Then I should see "Points - 45" in the "beginner" "table_row"
    And I navigate to "Course 2" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 77      |
    And I press "Save changes"
    Then I should see "Points - 77" in the "beginner" "table_row"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Donut')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Current level')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Next level points')]//input[@type='checkbox']" to "1"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I should see "0" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 70" in the ".skill-total-info .total-points" "css_element"
    And I should see "10 points to become beginner" in the ".next-level-info .info-str span" "css_element"
    And I am on the "Course 1" course page
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)"
    And I am on "Course 1" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 45)"
    And I follow "Dashboard"
    And I should see "Completed" in the ".points-info-box .skill-completed" "css_element"
    And I am on "Course 2" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 77)"
    And I follow "Dashboard"
    And I should see "Completed" in the ".points-info-box .skill-completed" "css_element"
    Then I log out
    And I log in as "admin"
    And I follow "Dashboard"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Conditions" "link" in the "Edit preferences" "dialogue"
    Then I should see "Limit data to" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//div[contains(normalize-space(.), 'Skills')]//input[@type='checkbox']" to "1"
    And I open the autocomplete suggestions list
    And I click on "Competence" item in the autocomplete list
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    Then I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I should see "0" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 40" in the ".skill-total-info .total-points" "css_element"
    And I should see "Competence" in the ".skill-basic-info .skill-name" "css_element"
    And I should see "10 points to become beginner" in the ".next-level-info .info-str span" "css_element"
    Then I log out

  @javascript
  Scenario: Show the skills of the owner
    Given I log in as "admin"
    And I create skill with the following fields to these values:
        | Skill name       | Beginner 2 |
        | Key              | beginner2  |
        | Number of levels | 2          |
        | Base level name    | beginner |
        | Base level point   | 10       |
        | Level #1 name    | Level 1    |
        | Level #1 point   | 20         |
        | Level #2 name    | Level 2    |
        | Level #2 point   | 30         |
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I add the "Dash" block
    And I click on "Skill progress" "radio"
    And I configure the "New Dash" block
    And I set the field "Block title" to "Skill progress"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I log out
    And I log in as "admin"
    And I navigate to "Course 1" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 45      |
    And I press "Save changes"
    Then I should see "Points - 45" in the "beginner" "table_row"
    And I navigate to "Course 2" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 77      |
    And I press "Save changes"
    Then I should see "Points - 77" in the "beginner" "table_row"
    And I click on ".skill-course-actions .action-edit" "css_element" in the "beginner2" "table_row"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 10      |
    And I press "Save changes"
    Then I should see "Points - 10" in the "beginner2" "table_row"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Donut')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Current level')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Next level points')]//input[@type='checkbox']" to "1"
    And I press "Save changes"
    And I click on "Reset Dashboard for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I should see "0" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 100 " in the ".skill-total-info .total-points" "css_element"
    And I should see "10 points to become beginner" in the ".next-level-info .info-str span" "css_element"
    And I am on the "Course 1" course page
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)"
    And I am on "Course 1" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 45)"
    And I follow "Dashboard"
    And I should see "Completed" in the ".points-info-box .skill-completed" "css_element"
    And I am on "Course 2" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 77)"
    And I follow "Dashboard"
    And I should see "Completed" in the ".points-info-box .skill-completed" "css_element"
    Then I log out
    And I log in as "admin"
    And I follow "Dashboard"
    And I navigate to "Appearance > Default Dashboard page" in site administration
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Conditions" "link" in the "Edit preferences" "dialogue"
    Then I should see "Limit data to" in the "Edit preferences" "dialogue"
    And I set the following fields to these values:
        | My skills | 1 |
    And I press "Save changes"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I log out
    And I log in as "admin"
    And I navigate to "Appearance > Default profile page" in site administration
    And I turn editing mode on
    And I add the "Dash" block
    And I click on "Skill progress" "radio"
    And I configure the "New Dash" block
    And I set the field "Block title" to "Skill progress"
    And I press "Save changes"
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Donut')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Current level')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Next level points')]//input[@type='checkbox']" to "1"
    And I press "Save changes"
    And I should see "0" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 100" in the ".skill-total-info .total-points" "css_element"
    And I should see "10 points to become beginner" in the ".next-level-info .info-str span" "css_element"
    And I click on "Reset profile for all users" "button"
    And I log out
    And I log in as "student1"
    And I follow "View profile"
    And I should see "100" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 100" in the ".skill-total-info .total-points" "css_element"
    And I should see "Level 2" in the ".skill-user-level .current-level-name" "css_element"
    And I log out
    And I log in as "admin"
    And I navigate to "Appearance > Default profile page" in site administration
    And I turn editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Conditions" "link" in the "Edit preferences" "dialogue"
    Then I should see "Limit data to" in the "Edit preferences" "dialogue"
    And I set the following fields to these values:
        | My skills | 1 |
    And I press "Save changes"
    And I click on "Reset profile for all users" "button"
    Then I log out
    And I log in as "student1"
    And I follow "View profile"
    And I should see "60" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 60" in the ".skill-total-info .total-points" "css_element"
    And I should see "Beginner" in the ".skill-basic-info .skill-name" "css_element"
    And I should see "Level 2" in the ".skill-user-level .current-level-name" "css_element"
    Then I log out

  @javascript
  Scenario: Show the user's current course skill
    Given I log in as "admin"
    And I am on the "Course 1" course page
    And I turn dash block editing mode on
    And I add the "Dash" block
    And I click on "Skill progress" "radio"
    And I configure the "New Dash" block
    And I set the field "Block title" to "Skill progress"
    And I press "Save changes"
    And I log out
    And I log in as "student1"
    And I follow "Dashboard"
    And I log out
    And I log in as "admin"
    And I navigate to "Course 1" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 45      |
    And I press "Save changes"
    Then I should see "Points - 45" in the "beginner" "table_row"
    And I navigate to "Course 2" course skills
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
        | Status                 | Enabled |
        | Upon course completion | Points  |
        | Points                 | 77      |
    And I press "Save changes"
    Then I should see "Points - 77" in the "beginner" "table_row"
    And I am on the "Course 1" course page
    And I turn dash block editing mode on
    And I click on "#action-menu-toggle-0" "css_element"
    And I click on "Preferences" "link" in the "Skill progress" "block"
    Then I click on "Fields" "link" in the "Edit preferences" "dialogue"
    Then I should see "Enabled fields" in the "Edit preferences" "dialogue"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Donut')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Current level')]//input[@type='checkbox']" to "1"
    And I set the field with xpath "//label[contains(normalize-space(.), 'Skills: Next level points')]//input[@type='checkbox']" to "1"
    Then I click on "Conditions" "link" in the "Edit preferences" "dialogue"
    Then I should see "Limit data to" in the "Edit preferences" "dialogue"
    And I set the following fields to these values:
        | Current course skills | 1 |
    And I press "Save changes"
    And I log out
    And I log in as "student1"
    And I am on the "Course 1" course page
    And I should see "0" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 30" in the ".skill-total-info .total-points" "css_element"
    And I should see "10 points to become beginner" in the ".next-level-info .info-str span" "css_element"
    And I am on the "Course 1" course page
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)"
    And I am on "Course 1" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 45)"
    And I am on the "Course 1" course page
    And I should see "Completed" in the ".points-info-box .skill-completed" "css_element"
    And I am on "Course 2" course homepage
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 77)"
    And I am on the "Course 1" course page
    And I should see "Completed" in the ".points-info-box .skill-completed" "css_element"
    Then I log out
    And I log in as "student1"
    And I am on the "Course 1" course page
    And I should see "30" in the ".skill-total-info .earned" "css_element"
    And I should see "/ 30" in the ".skill-total-info .total-points" "css_element"
    And I should see "Completed" in the ".points-info-box .skill-completed" "css_element"
