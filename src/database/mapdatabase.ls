/*
  This file is part of Buggy.

  Buggy is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Buggy is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Buggy.  If not, see <http://www.gnu.org/licenses/>.
*/


# this file implements a map representation of the database. This is the simplest and probably
# slowest method of implementing all data types. But it always works!

define ["ls!src/database/database", "src/util/map"] (Database, MapUtil) ->

  Database.create-model  {
    create: ->
      {}
    query: (db, what) ->
      MapUtil.find db, what

    # at this point it is already ensured that the value doesn't exist
    add: (db, what, content) ->
      # what specifies the name of the object not the actual content eg. "Index"
      # what can be a path like "Reports.Users.Activity"
      MapUtil.assign db, what, content


  }
