##############################################################################
#  Copyright 2011 Service Computing group, TU Dortmund
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##############################################################################

##############################################################################
# Description: OCCI Rendering
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/rendering/AbstractRenderer'
require 'occi/rendering/http/Renderer'

module OCCI
  module Rendering

    # ---------------------------------------------------------------------------------------------------------------------
    class Rendering

      # ---------------------------------------------------------------------------------------------------------------------
      # Prepare current rendering pass
      def self.prepare_renderer(content_type)
        @@request_content_type = content_type
        $log.error("No renderer registered for content type '%{content_type}'") unless @@renderers.has_key?(content_type)
        @@renderers[@@request_content_type].send(:prepare_renderer)
      end
  
      # ---------------------------------------------------------------------------------------------------------------------
      def self.register_renderer(content_type, renderer_instanz)
        @@renderers[content_type] = renderer_instanz
      end
  
      # ---------------------------------------------------------------------------------------------------------------------
      # TODO: implement mission methods stuff redirection -> content
      def method_missing(method, *args, &block)
        $log.debug("*** method missing: " + method.to_s)
        $log.debug("*** methods: " + AbstractRenderer.public_instance_methods.inspect)
        if AbstractRenderer.public_instance_methods.include?(method.to_s)
          $log.debug("*** calling rend...")
#          $log.debug()
          @@renderers[@@request_content_type].send(method, *args, &block)
        else
          super
        end
      end
  
      # ---------------------------------------------------------------------------------------------------------------------
      private
      # ---------------------------------------------------------------------------------------------------------------------
  
      # The content type for the curret request
      @@request_content_type = ""
  
      # Content-type -> renderer instance 
      @@renderers = {}

      # ---------------------------------------------------------------------------------------------------------------------
      # Register available renderer
      OCCI::Rendering::Rendering.register_renderer("text/occi",      OCCI::Rendering::HTTP::Renderer.new)
      OCCI::Rendering::Rendering.register_renderer("text/plain",     OCCI::Rendering::HTTP::Renderer.new)
      OCCI::Rendering::Rendering.register_renderer("text/uri-list",  OCCI::Rendering::HTTP::Renderer.new)

    end

  end
end