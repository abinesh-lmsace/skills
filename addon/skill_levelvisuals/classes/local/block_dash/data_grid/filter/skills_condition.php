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
 * Filters results to specific skills.
 *
 * @package    skilladdon_skill_levelvisuals
 * @copyright  2023 bdecent gmbh <https://bdecent.de>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace skilladdon_skill_levelvisuals\local\block_dash\data_grid\filter;

use block_dash\local\data_grid\filter\condition;
use coding_exception;
use moodleform;
use MoodleQuickForm;

/**
 * Filters results to specific sections.
 *
 * @package skilladdon_skill_levelvisuals
 */
class skills_condition extends condition {

    /**
     * Get filter SQL operation.
     *
     * @return string
     */
    public function get_operation() {
        return self::OPERATION_EQUAL;
    }

    /**
     * Get condition label.
     *
     * @return string
     * @throws coding_exception
     */
    public function get_label() {
        if ($label = parent::get_label()) {
            return $label;
        }

        return get_string('skills', 'block_dash');
    }

    /**
     * Get values from filter based on user selection. All filters must return an array of values.
     *
     * Override in child class to add more values.
     *
     * @return array
     */
    public function get_values() {

        if (isset($this->get_preferences()['skills']) && $this->get_preferences()['skills']) {
            $skills = $this->get_preferences()['skills'];
            return $skills;
        }
        return false;
    }

    /**
     * Return where SQL and params for placeholders.
     *
     * @return array
     * @throws \Exception
     */
    public function get_sql_and_params() {
        global $DB;

        $skills = $this->get_values();

        if (empty($skills)) {
            return ['', []];
        }

        return ["tsk.id = :skillid", ['skillid' => $skills]];
    }

    /**
     * Add form fields for this filter (and any settings related to this filter.)
     *
     * @param moodleform $moodleform
     * @param MoodleQuickForm $mform
     * @param string $fieldnameformat
     */
    public function build_settings_form_fields(
        moodleform $moodleform,
        MoodleQuickForm $mform,
        $fieldnameformat = 'filters[%s]'): void {
        global $PAGE;

        parent::build_settings_form_fields($moodleform, $mform, $fieldnameformat); // Always call parent.

        $fieldname = sprintf($fieldnameformat, $this->get_name());

        $skills = \tool_skills\helper::get_skills_list();
        $options = [];
        foreach ($skills as $skillobj) {
            $options[$skillobj->get_id()] = $skillobj->get_name();
        }
        $sections = $mform->addElement('autocomplete', $fieldname . '[skills]',
            get_string('skills', 'block_dash'), $options);
        $sections->setMultiple(false);

        $mform->hideIf($fieldname . '[skills]', $fieldname . '[enabled]');

    }
}
