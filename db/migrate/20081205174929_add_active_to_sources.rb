# $HeadURL: http://ambraproject.org/svn/plos/alm/head/db/migrate/20081205174929_add_active_to_sources.rb $
# $Id: 20081205174929_add_active_to_sources.rb 5693 2010-12-03 19:09:53Z josowski $
#
# Copyright (c) 2009-2010 by Public Library of Science, a non-profit corporation
# http://www.plos.org/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class AddActiveToSources < ActiveRecord::Migration
  class Source < ActiveRecord::Base; end

  def self.up
    add_column :sources, :active, :boolean, :default => true
  end

  def self.down
    remove_column :sources, :active
  end
end
