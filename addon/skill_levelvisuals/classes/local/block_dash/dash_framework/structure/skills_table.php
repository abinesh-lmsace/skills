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
 * Skills table for the skilladdon skill level visuals datasource.
 *
 * @package    skilladdon_skill_levelvisuals
 * @copyright  2023 bdecent gmbh <https://bdecent.de>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace skilladdon_skill_levelvisuals\local\dash_framework\structure;

use lang_string;
use block_dash\local\dash_framework\structure\field;
use block_dash\local\dash_framework\structure\table;
use block_dash\local\data_grid\field\attribute\identifier_attribute;

/**
 * Badges table structure definitions for badge datasource.
 */
class skills_table extends table {

    /**
     * Build a new table.
     */
    public function __construct() {
        parent::__construct('tool_skills', 'tsk');
    }

    /**
     * Get human readable title for table.
     *
     * @return string
     */
    public function get_title(): string {
        return get_string('tablealias_tsk', 'block_dash');
    }

    /**
     * Setup available fields for the table.
     *
     * @return field_interface[]
     * @throws \moodle_exception
     */
    public function get_fields(): array {

        $fields = [

            new field('id', new \lang_string('skills', 'block_dash'), $this, null, [
                new identifier_attribute(),
            ]),

            new field('currentlevel', new \lang_string('fieldcurrentlevel', 'block_dash'), $this),

            new field('alllevels', new lang_string('fieldalllevels', 'block_dash'), $this),

        ];
        return $fields;
    }
}
