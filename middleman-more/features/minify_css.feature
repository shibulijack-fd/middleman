Feature: Minify CSS
  In order reduce bytes sent to client and appease YSlow

  Scenario: Rendering external css with the feature disabled
    Given a fixture app "minify-css-app"
    And a file named "config.rb" with:
      """
      """
    And the Server is running at "minify-css-app"
    When I go to "/stylesheets/site.css"
    Then I should see "60" lines
    And I should see "only screen and (device-width"
    
  Scenario: Rendering external css with the feature enabled
    Given a fixture app "minify-css-app"
    And a file named "config.rb" with:
      """
      activate :minify_css
      """
    And the Server is running at "minify-css-app"
    When I go to "/stylesheets/site.css"
    Then I should see "1" lines
    And I should see "only screen and (device-width"
    When I go to "/more-css/site.css"
    Then I should see "1" lines    
    
  Scenario: Rendering external css with passthrough compressor
    Given a fixture app "passthrough-app"
    And a file named "config.rb" with:
      """
      module ::PassThrough
        def self.compress(data)
          data
        end
      end

      activate :minify_css

      set :css_compressor, ::PassThrough
      """
    And the Server is running at "passthrough-app"
    When I go to "/stylesheets/site.css"
    Then I should see "55" lines

  Scenario: Rendering inline css with the feature disabled
    Given a fixture app "minify-css-app"
    And a file named "config.rb" with:
      """
      """
    And the Server is running at "minify-css-app"
    When I go to "/inline-css.html"
    Then I should see:
    """
    <style type='text/css'>
      /*<![CDATA[*/
        body {
          test: style;
          good: deal;
        }
      /*]]>*/
    </style>
    """
   
  Scenario: Rendering inline css with a passthrough minifier
    Given a fixture app "passthrough-app"
    And a file named "config.rb" with:
      """
      module ::PassThrough
        def self.compress(data)
          data
        end
      end

      activate :minify_css, :inline => true

      set :css_compressor, ::PassThrough

      page "/inline-css.html", :layout => false
      """
    And the Server is running at "passthrough-app"
    When I go to "/inline-css.html"
    Then I should see:
    """
    <style type='text/css'>
      body {
        test: style;
        good: deal; }
    </style>
    """

  Scenario: Rendering inline css with the feature enabled
    Given a fixture app "minify-css-app"
    And a file named "config.rb" with:
      """
      activate :minify_css, :inline => true
      """
    And the Server is running at "minify-css-app"
    When I go to "/inline-css.html"
    Then I should see:
    """
    <style type='text/css'>
      /*<![CDATA[*/
     body{test:style;good:deal}
      /*]]>*/
    </style>
    """