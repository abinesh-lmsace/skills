<?php
// This file is part of The Bootstrap Moodle theme
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
 * Library functions defined for skill graph widget.
 *
 * @package    skilladdon_skill_levelvisuals
 * @copyright  2023 bdecent gmbh <https://bdecent.de>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * Register the skill level visuals as widget to dash.
 *
 * @return array List of widgets.
 */
function skilladdon_skill_levelvisuals_register_widget(): array {
    return [
        [
            'name' => get_string('widget:skilllevelvisuals', 'block_dash'),
            'identifier' => skilladdon_skill_levelvisuals\widget\levelvisuals_widget::class,
            'help' => 'widget:skilllevelvisuals',
        ],
    ];
}

