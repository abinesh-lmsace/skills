<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Mylearning widget class contains the courses user enrolled and not completed.
 *
 * @package    skilladdon_skillprogress
 * @copyright  2023 bdecent gmbh <https://bdecent.de>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace skilladdon_skillprogress\widget;

use block_dash\local\widget\abstract_widget;
use skilladdon_skillprogress\widget\skillprogress_layout;
use skilladdon_skillprogress\local\dash_framework\structure\skills_table;
use block_dash\local\data_source\form\preferences_form;
use block_dash\local\data_grid\filter\filter_collection;
use skilladdon_skillprogress\local\block_dash\data_grid\filter\skills_condition;
use skilladdon_skillprogress\local\block_dash\data_grid\filter\myskills_condition;
use skilladdon_skillprogress\local\block_dash\data_grid\filter\hidecompleted_condition;
use skilladdon_skillprogress\local\block_dash\data_grid\filter\currentcourseskill_condition;

/**
 * Skill Progress widget class generates data for users progress of their skills and levels.
 */
class skillprogress_widget extends abstract_widget {

    /**
     * Points user earned.
     *
     * @var array
     */
    protected $userpoints = [];

    /**
     * Construct method.
     *
     * @param \context $context
     */
    public function __construct($context) {
        // Skills table.
        $this->add_table(new skills_table());
        parent::__construct($context);
    }

    /**
     * Get the name of widget.
     *
     * @return void
     */
    public function get_name() {
        return get_string('widget:skillprogress', 'block_dash');
    }

    /**
     * Check the widget support uses the query method to build the widget.
     *
     * @return bool
     */
    public function supports_query() {
        return false;
    }

    /**
     * Layout class widget will use to render the widget content.
     *
     * @return \abstract_layout
     */
    public function layout() {
        return new skillprogress_layout($this);
    }

    /**
     * Pre defined preferences that widget uses.
     *
     * @return array
     */
    public function widget_preferences() {
        $preferences = [
            'datasource' => 'skillprogress',
            'layout' => 'skillprogress',
        ];
        return $preferences;
    }

    /**
     * Widget data count.
     *
     * @return void
     */
    public function widget_data_count() {
        return $this->data['skillscount'] ?? 0;
    }

    /**
     * Get current page user. if block added in the profile page then the current profile user is releate user
     * Otherwise logged in user is current user.
     *
     * @return int $userid
     */
    public function get_current_userid() {
        global $PAGE, $USER;

        if ($PAGE->pagelayout == 'mypublic') {
            $userid = optional_param('id', 0, PARAM_INT);
        }

        return isset($userid) && $userid ? $userid : $USER->id; // Owner of the page.
    }

    /**
     * Generate the user earned points, and grouped by skill.
     *
     * @return array
     */
    protected function get_user_points() {
        static $points;

        if ($points == null) {
            // Get current userid.
            $userid = $this->get_current_userid();
            // Get user points.
            $userpoints = \tool_skills\user::get($userid)->get_user_points(false);
            foreach ($userpoints as $skillpoint) {
                $points[$skillpoint->skill] = $skillpoint->points;
            }
        }

        return $points ?: [];
    }

    /**
     * Build widget data and send to layout thene the layout will render the widget.
     *
     * @return void
     */
    public function build_widget() {

        $this->data = [];

        $skills = $this->get_skills();

        if (empty($skills)) {
            $this->data = ['skills' => false, 'skillnoresult' => true];
            return $this->data;
        }

        $data = $this->generate_skills_data($skills);
        $this->data = $data;
        $this->data['skillnoresult'] = empty($data['skills']) && isset($data['hideskills']) && isset($data['hidedonut']);
        $this->data['skillscount'] = !empty($data['skills']) ? count($data['skills']) : 0;

        return $this->data;
    }

    /**
     * Get the skills user linked.
     *
     * @return array
     */
    public function get_skills() {
        global $DB;

        // Get filters.
        $filters = $this->get_filter_collection()->get_filters();
        $conditionsql = ['tsk.status = 1']; // Only active skills.
        $params = [];

        // Conditions.
        $conditions = ['tsk_skills', 'tsk_myskills', 'tsk_hcs', 'tsk_ccs'];
        foreach ($filters as $filter) {

            if (in_array($filter->get_name(), $conditions)) {
                list($insql, $inparams) = $filter->get_sql_and_params();
                $conditionsql[] = ($insql) ? " $insql " : '';
                $params += $inparams ?: [];
            }

        }

        // Generate condition sql.
        $conditions = (!empty($conditionsql)) ? implode(' AND ', array_filter($conditionsql)) : '';
        $sql = "SELECT id FROM {tool_skills} tsk WHERE $conditions";

        // Fetch the list of skills based on the condition.
        $skills = $DB->get_records_sql($sql, $params);

        foreach ($skills as $k => $skill) {
            $skills[$k] = \tool_skills\skills::get($skill->id);
        }

        return $skills;
    }

    /**
     * Generate skills data.
     *
     * @param array $skills
     * @return void
     */
    protected function generate_skills_data(array $skills) {

        $fields = !empty($this->get_preferences('available_fields')) ? $this->get_preferences('available_fields') : [];

        $enabledfields = array_filter($fields,
            fn($option, $field) => isset($option['visible']) ? $option['visible'] : 0, ARRAY_FILTER_USE_BOTH);

        $result = ['fields' => $enabledfields];

        // Show individual skills and its levels data.
        if (!isset($enabledfields['tsk_hideindividualskills'])) {
            $result['skills'] = $this->get_skills_data($skills, $enabledfields);
        } else {
            $result['hideskills'] = true;
        }

        // Display the overall skill progress as donut.
        if (isset($enabledfields['tsk_donut'])) {
            $data = $this->get_donut($skills);
            $result['tsk_donut'] = $data;
        } else {
            $result['hidedonut'] = true;
        }

        return $result;
    }

    /**
     * Get the skills data.
     *
     * @param array $skills
     * @param array $fields
     * @return void
     */
    protected function get_skills_data(array $skills, array $fields) {

        if (!empty($skills)) {

            $userpoints = $this->get_user_points();

            foreach ($skills as $skill) {

                // Find the progress of the user in this skill.
                $earnedpoint = $userpoints[$skill->get_id()] ?? 0;
                $skillpoints = $skill->get_points_to_earnskill();

                if ($skillpoints <= 0) {
                    continue;
                }

                $progress = round(($earnedpoint / $skillpoints) * 100);
                $progress = $progress > 100 ? 100 : $progress;

                $deg1 = $progress >= 50 ? 50 : $progress;
                $deg2 = $progress <= 50 ? 0 : ($progress - $deg1);

                $data = [
                    'skillname' => $skill->get_name(),
                    'progress' => $progress,
                    'deg1' => $deg1,
                    'deg2' => $deg2,
                    // Show the max mark if the points are high.
                    'earned' => ($earnedpoint <= $skillpoints) ? $earnedpoint : $skillpoints,
                    'skillpoints' => $skillpoints,
                    'color' => $skill->get_data()->color ?: "var(--info)",
                    'completed' => ($progress >= 100),
                ];

                // Generate the level related data.
                // Find the next level and the needed points to reach the next level.
                // Generate the current level data.
                if (isset($fields['tsk_currentlevel']) || isset($fields['tsk_nextlevelpoints'])) {
                    $levels = $skill->get_levels();
                    $leveldata = [];
                    if (empty($levels)) {
                        // No levels found move to next skill.
                        $result[] = $data;
                        continue;
                    }

                    $currentlevel = false;
                    $nextlevel = reset($levels);

                    foreach ($levels as $level) {

                        // Verify the user earned points is more than this level points.
                        // Then set this level as complete and remove the level points from earnedpoint to verify the next levels.
                        if ($earnedpoint >= $level->points) {
                            $currentlevel = $level;
                            // Create a next level flag.
                            $nextlevel = next($levels) ?: [];
                        }
                    }

                    // Current user level in the skill.
                    if (isset($fields['tsk_currentlevel'])) {
                        $leveldata = [
                            'currentlevelname' => $currentlevel ? format_string($currentlevel->name) : ''];
                    }

                    if ($nextlevel && isset($fields['tsk_nextlevelpoints'])) {
                        // Points for the next level.
                        $nextlevelpoints = $nextlevel->points;
                        // Points to reach the next level.
                        $pointstoreach = $earnedpoint < $nextlevelpoints ? $nextlevelpoints - $earnedpoint : 0;

                        $leveldata += [
                            'pointstoreach' => $pointstoreach,
                            'nextlevelname' => format_string($nextlevel->name),
                            'nextlevelstr' => get_string('nextlevelstr', 'block_dash', [
                                'name' => format_string($nextlevel->name),
                                'points' => $pointstoreach,
                            ]),
                        ];
                    }

                    $data['level'] = $leveldata;

                }

                $result[] = $data; // Attach the current skill generated data to the results.
            }
        }

        return $result ?? [];
    }

    /**
     * Skills donut.
     *
     * @param array $skills
     * @return void
     */
    protected function get_donut($skills) {

        $totalpoints = array_sum(array_map(fn($skill) => $skill->get_points_to_earnskill(), $skills));

        $userpoints = $this->get_user_points();

        $pointsearned = array_sum(array_map(function($skill) use ($userpoints) {
            return $userpoints[$skill->get_id()] ?? 0;
        }, $skills));

        $progress = ($pointsearned / $totalpoints);
        $percentage = ($progress) * 100;
        $percentage = $percentage > 100 ? 100 : $percentage;

        // Make the course progress as circle.
        if (!empty($percentage)) {
            $deg = (int) (($percentage / 100 ) * 360);
            $deg1 = $deg;
            if ($deg > 180) {
                $deg1 = '180';
                $deg2 = (int) $deg - $deg1;
            }

            if (right_to_left()) {
                $deg1 = '-'.$deg1;
                if (isset($deg2)) {
                    $deg2 = '-'.$deg2;
                }
            }
        }

        return [
            'totalpoints' => $totalpoints,
            'userpoints' => $userpoints,
            'pointsearned' => $pointsearned > $totalpoints ? $totalpoints : $pointsearned,
            'percentage' => round(($percentage > 100 ? 100 : $percentage)),
            'deg1' => $deg1 ?? 0,
            'deg2' => $deg2 ?? 0,
        ];
    }

    /**
     * Get the current level.
     *
     * @param \tool_skills\skills $skill
     * @param int $earnedpoint
     *
     * @return \tool_skills\level
     */
    protected function get_currentlevel(\tool_skills\skills $skill, int $earnedpoint) {
        // Levels.
        $levels = $skill->get_levels();
        foreach ($levels as $level) {
            if ($earnedpoint >= $level->points) {
                $proficiencylevel = $level;
            }
        }

        return $proficiencylevel;
    }

    /**
     * Prefence form for widget. We make the fields disable other than the general.
     *
     * @param \moodleform $form
     * @param \MoodleQuickForm $mform
     * @return void
     */
    public function build_preferences_form(\moodleform $form, \MoodleQuickForm $mform) {

        if ($form->get_tab() == preferences_form::TAB_GENERAL) {
            $mform->addElement('static', 'data_source_name', get_string('datasource', 'block_dash'), $this->get_name());
        }

        if ($layout = $this->get_layout()) {
            $layout->build_preferences_form($form, $mform);
        }
    }

    /**
     * Build and return filter collection.
     *
     * @return filter_collection_interface
     * @throws coding_exception
     */
    public function build_filter_collection() {

        $filtercollection = new filter_collection(get_class($this), $this->get_context());

        $filtercollection->add_filter(new skills_condition('tsk_skills', ''));

        $filtercollection->add_filter(new myskills_condition('tsk_myskills', ''));

        $filtercollection->add_filter(new hidecompleted_condition('tsk_hcs', ''));

        $filtercollection->add_filter(new currentcourseskill_condition('tsk_ccs', ''));

        return $filtercollection;
    }
}
