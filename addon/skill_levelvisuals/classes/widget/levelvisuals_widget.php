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
 * Skill level visuals widget generates the users assigned levels and reached levels visual representations.
 *
 * @package    skilladdon_skill_levelvisuals
 * @copyright  2023 bdecent gmbh <https://bdecent.de>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace skilladdon_skill_levelvisuals\widget;

use block_dash\local\widget\abstract_widget;
use skilladdon_skill_levelvisuals\widget\levelvisuals_layout;
use skilladdon_skill_levelvisuals\local\dash_framework\structure\skills_table;
use block_dash\local\data_source\form\preferences_form;
use block_dash\local\data_grid\filter\filter_collection;
use skilladdon_skill_levelvisuals\local\block_dash\data_grid\filter\skills_condition;

/**
 * Skill levels visual widget class contains the list of levels available for the selected skill.
 */
class levelvisuals_widget extends abstract_widget {

    /**
     * List of points user earned.
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
        return get_string('widget:skilllevelvisuals', 'block_dash');
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
        return new levelvisuals_layout($this);
    }

    /**
     * Pre defined preferences that widget uses.
     *
     * @return array
     */
    public function widget_preferences() {

        $preferences = [
            'datasource' => 'skill_levelvisuals',
            'layout' => 'skill_levelvisuals',
        ];
        return $preferences;
    }

    /**
     * Widget data count.
     *
     * @return void
     */
    public function widget_data_count() {
        return $this->data['levelscount'] ?? 0;
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

        return isset($userid) && $userid ? $userid : $USER->id;       // Owner of the page.
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

        list($levels, $completed) = $this->get_levels();

        if (empty($levels)) {
            $this->data = ['levels' => false, 'levelnoresult' => true];
            return $this->data;
        }

        $fields = !empty($this->get_preferences('available_fields')) ? $this->get_preferences('available_fields') : [];

        $currentlevel = $fields['tsk_currentlevel']['visible'] ?? 0;
        $alllevels = $fields['tsk_alllevels']['visible'] ?? 0;

        // Levels data.
        $this->data = [
            'levels' => $alllevels ? array_values($levels) : [],
            'showcurrentlevel' => $currentlevel ? true : false,
            'showalllevels' => $alllevels ? true : false,
            'completed' => $completed,
            'levelscount' => count($levels),
        ];

        $this->data['levelnoresult'] = (!$currentlevel || empty($completed)) && !$alllevels;

        return $this->data;
    }

    /**
     * Get the levels of the user assigned skills.
     *
     * @return array
     */
    public function get_levels() {
        global $DB;

        // Get filters.
        $filter = $this->get_filter_collection()->get_filter('tsk_skills');
        $conditionsql = ['tsk.status = 1']; // Only active skills.

        list($insql, $inparams) = $filter->get_sql_and_params();

        if (empty($inparams)) {
            return [[], []];
        }

        $conditionsql[] = ($insql) ? " $insql " : '';
        $params = $inparams ?: [];

        $skillid = $inparams['skillid'];
        $userpoints = $this->get_user_points();
        $earnedpoint = $userpoints[$skillid] ?? 0;

        // Generate condition sql.
        $conditions = (!empty($conditionsql)) ? implode(' AND ', array_filter($conditionsql)) : '';

        $sql = "SELECT tsl.*, tsk.name as skillname FROM {tool_skills_levels} tsl
            JOIN {tool_skills} tsk ON tsk.id = tsl.skill WHERE $conditions";
        // Fetch the list of skills based on the condition.
        $levels = $DB->get_records_sql($sql, $params);

        $result = $completed = [];

        foreach ($levels as $k => $level) {

            $leveldata = [
                'id' => $level->id,
                'name' => format_string($level->name),
                'points' => $level->points,
                'image' => $this->get_level_images($level),
                'color' => $level->color,
            ];

            if ($earnedpoint >= $level->points) {
                $completed[] = $leveldata; // All completed levels.
                $leveldata['completed'] = true;
            }

            $result[$level->id] = $leveldata;
        }

        // Find the completed level.
        $currentlevel = !empty($completed) ? end($completed) : [];

        if ($currentlevel) {
            $result[$currentlevel['id']]['currentlevel'] = true;
        }

        return [$result, $currentlevel];
    }

    /**
     * Get the level images.
     *
     * @param \stdclass $level
     * @return void
     */
    protected function get_level_images(\stdclass $level) {

        // Get area files.
        $files = get_file_storage()->get_area_files(
            \context_system::instance()->id, 'tool_skills', 'levelimage', $level->id, '', false
        );
        // Generate new pattern for levels with empty image.
        if (empty($files)) {
            $color = $level->color ?: '#cccccc';
            $pattern = new \core_geopattern();
            $pattern->setColor($color);
            $pattern->patternbyid('level-'.$level->id);
            return $pattern->datauri();
        }

        // Get the current file.
        $file = current($files);

        // Generate the URL.
        $fileurl = \moodle_url::make_pluginfile_url(
            $file->get_contextid(),
            $file->get_component(),
            $file->get_filearea(),
            $file->get_itemid(),
            $file->get_filepath(),
            $file->get_filename(), false
        );

        return $fileurl->out(false);
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
        global $PAGE;

        $filtercollection = new filter_collection(get_class($this), $this->get_context());

        $filtercollection->add_filter(new skills_condition('tsk_skills', ''));

        return $filtercollection;
    }
}
