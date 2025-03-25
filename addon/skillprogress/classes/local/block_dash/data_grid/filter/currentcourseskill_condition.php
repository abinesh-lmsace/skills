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
 * Filters results to specific sections.
 *
 * @package    skilladdon_skillprogress
 * @copyright  2023 bdecent gmbh <https://bdecent.de>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace skilladdon_skillprogress\local\block_dash\data_grid\filter;

use block_dash\local\data_grid\filter\condition;
use coding_exception;
use dml_exception;
use moodleform;
use MoodleQuickForm;
use core_competency\api;
use dashaddon_content\local\block_dash\content_customtype;

/**
 * Filters results to specific sections.
 *
 * @package skilladdon_skillprogress
 */
class currentcourseskill_condition extends condition {

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

        return get_string('currentcourseskills', 'block_dash');
    }

    /**
     * Get values from filter based on user selection. All filters must return an array of values.
     *
     * Override in child class to add more values.
     *
     * @return array
     */
    public function get_values() {

        if (isset($this->get_preferences()['enabled']) && ($this->get_preferences()['enabled'])) {
            return true;
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
        global $DB, $COURSE;

        $sql = ''; // SQL Query.
        $inparams = []; // IN params.

        $skills = $this->get_values();

        if (!$skills) {
            return [$sql, $inparams];
        }

        $courseskills = \tool_skills\courseskills::get($COURSE->id)->get_instance_skills();

        // Skills id from course skills.
        $skills = array_map(fn($sk) => $sk->get_id(), $courseskills);

        $sql = 'tsk.id = 0'; // Default query to prevent the skills list, if no course skills are found dont fetch any skill.
        if (!empty($skills)) {

            list($insql, $inparams) = $DB->get_in_or_equal($skills, SQL_PARAMS_NAMED, 'tskues');
            $sql = "tsk.id $insql";

        }

        return [$sql, $inparams];
    }
}
