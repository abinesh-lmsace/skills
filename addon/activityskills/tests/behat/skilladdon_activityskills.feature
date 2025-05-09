@tool @tool_skills @skilladdon @skilladdon_activityskills
Feature: Allocate skill points to the users based on activity completion
  In order to use the features
  As admin
  I need to be able to configure the tool skills plugin

  Background:
    Given the following "categories" exist:
      | name  | category | idnumber |
      | Cat 1 | 0        | CAT1     |
    And the following "course" exist:
      | fullname    | shortname | category | enablecompletion |
      | Course 1    | C1        | 0        |  1         |
      | Course 2    | C2        | 0        |  1         |
      | Course 3    | C3        | 0        |  1         |
    And the following "activities" exist:
      | activity | name       | course | idnumber  |  intro           | section |completion|
      | page     | Test page1 | C1     | page1     | Page description | 1       | 1 |
      | page     | Test page2 | C2     | page1     | Page description | 2       | 1 |
      | page     | Test page3 | C3     | page1     | Page description | 3       | 1 |
      | quiz     | Quiz1      | C1     | quiz1     | Page description | 1       | 1 |
      | page     | Test page4 | C1     | page1     | Page description | 1       | 1 |
      | assign   | Assign1    | C1     | assign1   | Page description | 1       | 1 |
    And the following "users" exist:
      | username | firstname | lastname | email                   |
      | student1 | Student   | First    | student1@example.com    |
      | student2 | Student   | Two      | student2@example.com    |
      | student3 | Student   | Three    | student3@example.com    |
    And the following "course enrolments" exist:
      | user | course | role             |   timestart | timeend   |
      | student1 | C1 | student          |   0         |     0     |
      | student1 | C2 | student          |   0         |     0     |
      | student1 | C3 | student          |   0         |     0     |
      | student2 | C2 | student          |   0         |     0     |
      | student2 | C3 | student          |   0         |     0     |
      | admin    | C1 | manager          |   0         |     0     |
      | admin    | C2 | manager          |   0         |     0     |
    And I log in as "admin"
    And I am on "Course 1" course homepage
    And I navigate to "Course completion" in current page administration
    And I expand all fieldsets
    And I set the field "Test page1" to "1"
    And I set the field "Quiz1" to "1"
    And I set the field "Test page4" to "1"
    And I set the field "Assign1" to "1"
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
    And ".skill-item-actions .toolskills-status-switch.action-hide" "css_element" should exist in the "beginner" "table_row"
    And I create skill with the following fields to these values:
      | Skill name       | Competence |
      | Key              | competence |
      | Number of levels | 2          |
      | Base level name    | beginner   |
      | Base level point   | 10         |
      | Level #1 name    | Level 1    |
      | Level #1 point   | 20         |
      | Level #2 name    | Level 2    |
      | Level #2 point   | 30         |
    And ".skill-item-actions .toolskills-status-switch.action-hide" "css_element" should exist in the "competence" "table_row"
    And I create skill with the following fields to these values:
      | Skill name       | Expert     |
      | Key              | expert     |
      | Number of levels | 2          |
      | Base level name    | beginner   |
      | Base level point   | 10         |
      | Level #1 name    | Level 1    |
      | Level #1 point   | 20         |
      | Level #2 name    | Level 2    |
      | Level #2 point   | 30         |
    And ".skill-item-actions .toolskills-status-switch.action-hide" "css_element" should exist in the "expert" "table_row"
    And I navigate to "Course 1" course skills
    And I click on ".skill-course-actions .action-edit" "css_element" in the "beginner" "table_row"
    And I set the following fields to these values:
      | Status                 | Enabled  |
      | Upon course completion | Points   |
      | Points                 | 200      |
    And I press "Save changes"
    And I click on ".skill-course-actions .action-edit" "css_element" in the "competence" "table_row"
    And I set the following fields to these values:
      | Status                 | Enabled  |
      | Upon course completion | Points   |
      | Points                 | 200      |
    And I press "Save changes"
    And I click on ".skill-course-actions .action-edit" "css_element" in the "expert" "table_row"
    And I set the following fields to these values:
      | Status                 | Enabled  |
      | Upon course completion | Points   |
      | Points                 | 200      |
    And I press "Save changes"
    And I navigate to "Course 2" course skills
    And I click on ".skill-course-actions .action-edit" "css_element" in the "beginner" "table_row"
    And I set the following fields to these values:
      | Status                 | Enabled  |
      | Upon course completion | Points   |
      | Points                 | 150      |
    And I press "Save changes"
    And I click on ".skill-course-actions .action-edit" "css_element" in the "competence" "table_row"
    And I set the following fields to these values:
      | Status                 | Enabled  |
      | Upon course completion | Points   |
      | Points                 | 150      |
    And I press "Save changes"
    And I click on ".skill-course-actions .action-edit" "css_element" in the "expert" "table_row"
    And I set the following fields to these values:
      | Status                 | Enabled  |
      | Upon course completion | Points   |
      | Points                 | 150      |
    And I press "Save changes"

  #1. Assign points to the user during an activity
  @javascript
  Scenario: Assign points to the user during an activity
    Given I am on the "Test page1" "page activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner" in the "mod_skills_list" "table"
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
      | Upon activity completion | Points |
      | Points                   | 30     |
    And I press "Save changes"
    Then I should see "Points - 30" in the "beginner" "table_row"
    And I am on the "Test page2" "page activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner"
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
      | Upon activity completion | Points |
      | Points                   | 20     |
    And I press "Save changes"
    Then I should see "Points - 20" in the "beginner" "table_row"
    And I am on the "Test page1" "page activity" page
    And I navigate to "Settings" in current page administration
    And I expand all fieldsets
    And I set the following fields to these values:
      | Add requirements         | 1                  |
      | id_completionview        | 1                  |
    And I press "Save and return to course"
    And I log out
    And I am on the "Course 1" course page logged in as student1
    And I am on the "student1" "user > profile" page
    And I should see "Points to complete this skill: 30 (Earned: 0)" in the ".skill-beginner" "css_element"
    And I am on "Course 1" course homepage
    And I am on the "Test page1" "page activity" page
    And I should see "Done: View"
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 30)" in the ".page1" "css_element"
    And I log out
    And I am on the "Course 2" course page logged in as student1
    And I am on the "Test page2" "page activity" page
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 20)" in the ".page2" "css_element"

  #2. Assign Negative points to the user during an activity
  @javascript
  Scenario: Assign Negative points to the user during an activity
    Given I am on the "Test page1" "page activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner" in the "mod_skills_list" "table"
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
      | Upon activity completion | Points |
      | Points                   | -50    |
    And I press "Save changes"
    Then I should see "Points - -50" in the "beginner" "table_row"
    And I log out
    And I am on the "Course 1" course page logged in as student1
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)"
    And I am on the "Test page1" "page activity" page
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: -50)" in the ".page1" "css_element"

  #3. Elevate the user's level upon completing an activity
  @javascript
  Scenario: Elevate the user's level upon completing an activity
    Given I am on the "Test page1" "page activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner" in the "mod_skills_list" "table"
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
      | Upon activity completion | Set level |
      | Level                    | beginner  |
    And I press "Save changes"
    Then I should see "Set level - beginner" in the "beginner" "table_row"
    And I am on the "Quiz1" "quiz activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner" in the "mod_skills_list" "table"
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
      | Upon activity completion | Set level |
      | Level                    | Level 1  |
    And I press "Save changes"
    Then I should see "Set level - Level 1" in the "beginner" "table_row"
    And I am on the "Test page4" "page activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner" in the "mod_skills_list" "table"
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
      | Upon activity completion | Set level |
      | Level                    | Level 2  |
    And I press "Save changes"
    Then I should see "Set level - Level 2" in the "beginner" "table_row"
    And I log out
    And I am on the "Course 1" course page logged in as student1
    And I am on the "student1" "user > profile" page
    And I should see "Points to complete this skill: 30 (Earned: 0)" in the ".skill-beginner" "css_element"
    And I am on the "Quiz1" "quiz activity" page
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 20)" in the ".skills-points-Quiz1" "css_element"

  #4. Force the user to change their level
  @javascript
  Scenario: Force the user to change their level
    Given I am on the "Test page1" "page activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner" in the "mod_skills_list" "table"
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
      | Upon activity completion | Set level |
      | Level                    | Level 1   |
    And I press "Save changes"
    Then I should see "Set level - Level 1" in the "beginner" "table_row"
    And I am on the "Test page4" "page activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner" in the "mod_skills_list" "table"
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
      | Upon activity completion | Force level |
      | Level                    | beginner    |
    And I press "Save changes"
    Then I should see "Force level - beginner" in the "beginner" "table_row"
    And I log out
    And I am on the "Course 1" course page logged in as student1
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)" in the ".skill-beginner" "css_element"
    And I am on the "Test page1" "page activity" page
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 20)" in the ".page1" "css_element"
    And I am on the "Test page4" "page activity" page
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 10)"

  #5. Set the user to attain points corresponding to their grade level
  @javascript
  Scenario: Set the user to attain points corresponding to their grade level
    Given I am on the "Assign1" "assign activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner" in the "mod_skills_list" "table"
    And I click on ".skill-course-actions .action-edit" "css_element"
    And I set the following fields to these values:
      | Upon activity completion | Points by grade |
    And I press "Save changes"
    Then I should see "Points by grade" in the "beginner" "table_row"
    When I am on the "Assign1" "assign activity" page
    And I navigate to "Settings" in current page administration
    And I set the following fields to these values:
      | Grade to pass    | 50.00 |
    And I press "Save and return to course"
    And I log out
    And I am on the "Course 1" course page logged in as student1
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)" in the ".skill-beginner" "css_element"
    And I am on the "Assign1" "assign activity" page
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 0)" in the ".skills-points-Assign1" "css_element"
    And I log out
    When I am on the "Assign1" "assign activity" page logged in as admin
    And I click on assignment view submissions link
    And I click on "#action-menu-1" "css_element" in the "Student First" "table_row"
    And I choose "Grade" in the open action menu
    When I set the following fields to these values:
      | Grade out of 100  | 60 |
    And I press "Save changes"
    And I should see "Graded"
    And I log out
    And I am on the "Course 1" course page logged in as student1
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 60)" in the ".skills-points-Assign1" "css_element"

  #6. Calculate the average points for 3 different skill in a single activity
  @javascript
  Scenario: Calculate the average points for 3 different skill in a single activity
    Given I am on the "Test page1" "page activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Beginner" in the "mod_skills_list" "table"
    And I click on ".skill-course-actions .action-edit" "css_element" in the "beginner" "table_row"
    And I set the following fields to these values:
      | Upon activity completion | Points |
      | Points                   | 5      |
    And I press "Save changes"
    Then I should see "Points - 5" in the "beginner" "table_row"
    And I am on the "Quiz1" "quiz activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Competence"
    And I click on ".skill-course-actions .action-edit" "css_element" in the "competence" "table_row"
    And I set the following fields to these values:
      | Upon activity completion | Set level |
      | Level                    | Level 2   |
    And I press "Save changes"
    Then I should see "Set level - Level 2" in the "competence" "table_row"
    And I am on the "Test page4" "page activity" page
    And I click on "More" "link" in the ".secondary-navigation" "css_element"
    And I click on "Manage skills" "link"
    And I should see "Expert"
    And I click on ".skill-course-actions .action-edit" "css_element" in the "expert" "table_row"
    And I set the following fields to these values:
      | Upon activity completion | Force level  |
      | Level                    | beginner     |
    And I press "Save changes"
    Then I should see "Force level - beginner" in the "expert" "table_row"
    And I log out
    And I am on the "student1" "user > profile" page logged in as student1
    And I should see "Points to complete this skill: 30 (Earned: 0)" in the ".skill-beginner" "css_element"
    And I am on the "Test page1" "page activity" page
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    And I should see "(Earned: 5)" in the ".page1" "css_element"
    And I am on the "Quiz1" "quiz activity" page
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 30)" in the ".skills-points-Quiz1" "css_element"
    And I am on the "Test page4" "page activity" page
    And I press "Mark as done"
    And I wait until "Done" "button" exists
    And I am on the "student1" "user > profile" page
    Then I should see "(Earned: 10)" in the ".page4" "css_element"
