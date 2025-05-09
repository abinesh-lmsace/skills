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
 * Tool Skill addon - List of events to observe.
 *
 * @package   skilladdon_activityskills
 * @copyright 2023 bdecent GmbH <https://bdecent.de>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

defined('MOODLE_INTERNAL') || die();

$observers = [
    [
        'eventname' => '\core\event\course_module_completion_updated',
        'callback' => '\skilladdon_activityskills\eventobservers::course_module_completed',
    ],
    [
        'eventname' => 'core\event\course_module_deleted',
        'callback' => '\skilladdon_activityskills\eventobservers::course_module_deleted',
    ],
    [
        'eventname' => 'mod_assign\event\submission_graded',
        'callback' => '\skilladdon_activityskills\eventobservers::manage_user_graded',
    ],
    [
        'eventname' => 'mod_quiz\event\attempt_submitted',
        'callback' => '\skilladdon_activityskills\eventobservers::manage_user_graded',
    ],
];
