# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Utils to seed sample database
class SeedUtils

  PARAGRAPHS = ['Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam posuere volutpat arcu eu imperdiet. Donec lacinia faucibus enim, ac blandit nisi rhoncus non. Vestibulum sollicitudin faucibus nisi in facilisis. In venenatis, nibh at auctor vehicula, diam nibh congue mi, eleifend placerat leo tortor interdum purus. Maecenas cursus accumsan tortor, eget tincidunt nisi viverra sit amet. Suspendisse tempus sem sit amet magna fermentum at eleifend diam sollicitudin.',

                'Phasellus et sem sed lorem imperdiet rhoncus non sit amet magna. Integer aliquet felis sem, rhoncus fermentum magna. Pellentesque non magna et lorem posuere placerat nec commodo ipsum. Mauris rutrum arcu quis mauris pharetra pretium. Suspendisse pharetra faucibus diam vel egestas. Mauris scelerisque varius tincidunt. Mauris interdum, lectus sit amet dictum tincidunt, enim velit lacinia magna, sed viverra odio magna vel ipsum. Nulla lacus arcu, facilisis et pellentesque tempor, lobortis quis ipsum.',

                'Maecenas porttitor viverra elit, vel sollicitudin risus faucibus ut. Aliquam erat volutpat. Aliquam eu consequat sem. Etiam nibh tortor, feugiat nec sollicitudin sed, placerat sit amet mauris. Praesent vestibulum consectetur velit vel iaculis. Nullam eget sodales tortor. Suspendisse malesuada posuere lectus, ac convallis elit dignissim at. Pellentesque gravida fringilla orci. Suspendisse sodales tristique placerat. Pellentesque nisl massa, adipiscing sit amet adipiscing a, bibendum quis velit.',

                'Aliquam sed eros ac lorem aliquam iaculis non tempus nunc. Aenean id urna lacus. Etiam non augue justo, vel ornare quam. Proin blandit tincidunt mauris eu convallis. Integer enim elit, sollicitudin vitae tincidunt non, tristique ac sapien. Vestibulum cursus venenatis tincidunt. Integer non semper quam. Sed sed dolor felis. Ut in lorem at magna pharetra egestas quis ac velit. Ut quam velit, hendrerit vitae vehicula et, tempus sed orci. Aliquam erat volutpat.',

                'Faucibus nunc nisi, porta et ultrices at, faucibus sit amet neque. Quisque tincidunt sollicitudin gravida. Praesent vel metus id eros condimentum adipiscing. Ut mauris dui, sodales ac luctus quis, fringilla ut libero. Sed eu quam a risus vulputate varius. Aenean eu velit id urna laoreet pulvinar. Nam vitae malesuada leo. Donec id mauris lorem, eget blandit lacus. Curabitur a eros erat. Sed et nisl eget justo suscipit varius.']

  # From http://www.dack.com/web/bullshit.html
  VERBS = ['implement', 'utilize', 'integrate', 'streamline', 'optimize', 'evolve', 'transform', 'embrace', 'enable',
           'orchestrate', 'leverage', 'reinvent', 'aggregate', 'architect', 'enhance', 'incentivize', 'morph',
           'empower', 'envisioneer', 'monetize', 'harness', 'facilitate', 'seize', 'disintermediate', 'synergize',
           'strategize', 'deploy', 'brand', 'grow', 'target', 'syndicate', 'synthesize', 'deliver', 'mesh', 'incubate',
           'engage', 'maximize', 'benchmark', 'expedite', 'reintermediate', 'whiteboard', 'visualize', 'repurpose',
           'innovate', 'scale', 'unleash', 'drive', 'extend', 'engineer', 'revolutionize', 'generate', 'exploit',
           'transition', 'e-enable', 'iterate', 'cultivate']

  ADJECTIVES = ['clicks-and-mortar', 'value-added', 'vertical', 'proactive', 'robust', 'revolutionary', 'scalable',
                'leading-edge', 'innovative', 'intuitive', 'strategic', 'e-business', 'mission-critical', 'sticky',
                'one-to-one', '24/7', 'end-to-end', 'global', 'B2B', 'B2C', 'granular', 'frictionless', 'virtual',
                'viral', 'dynamic', '24/365', 'best-of-breed', 'killer', 'magnetic', 'bleeding-edge', 'web-enabled',
                'interactive', 'dot-com', 'sexy', 'back-end', 'real-time', 'efficient', 'front-end', 'distributed',
                'seamless', 'extensible', 'turn-key', 'world-class', 'open-source', 'cross-platform', 'cross-media',
                'synergistic', 'bricks-and-clicks', 'out-of-the-box', 'enterprise', 'integrated', 'impactful',
                'wireless', 'transparent', 'next-generation', 'cutting-edge', 'user-centric', 'visionary',
                'customized', 'ubiquitous', 'plug-and-play', 'collaborative', 'compelling', 'holistic']

  NOUNS = ['synergies', 'web-readiness', 'paradigms', 'markets', 'partnerships', 'infrastructures', 'platforms',
           'initiatives', 'channels', 'eyeballs', 'communities', 'ROI', 'solutions', 'e-tailers', 'e-services',
           'action-items', 'portals', 'niches', 'technologies', 'content', 'vortals', 'supply-chains', 'convergence',
           'relationships', 'architectures', 'interfaces', 'e-markets', 'e-commerce', 'systems', 'bandwidth',
           'infomediaries', 'models', 'mindshare', 'deliverables', 'users', 'schemas', 'networks', 'applications',
           'metrics', 'e-business', 'functionalities', 'experiences', 'methodologies']

  NAMES = ['Frank', 'Joe', 'Sally', 'Fred', 'Bob', 'Alice', 'George', 'John', 'Jim', 'Jennifer']

  class << self
    def add_comments(post)
      comments = 1 + rand(2)
      (0...comments).each do
        name = SeedUtils.name
        count = 1 + rand(2)
        post.comments.create(:name => name, :email => SeedUtils.email(name), :detail => SeedUtils.greek_paragraphs(count))
      end
    end

    def create_post(blog, value)
      (0...value).each do
        post = blog.posts.create(:title => SeedUtils.title, :detail => SeedUtils.greek_paragraphs)
        SeedUtils.add_comments post
      end
    end

   def email(value)
      noun = NOUNS[rand(42)].downcase
      value.downcase + '@' + noun + '.com'
    end

    def greek_paragraph
      PARAGRAPHS[rand(4)]
    end

    # Calculate a quasi-random number of paragraphs
    def greek_paragraphs(value=5)
      value = 5 if value > 5
      value = 1 + rand(value - 1)
      base = value - rand(4)
      base = 0 if base < 0
      paragraphs = PARAGRAPHS.shuffle.slice(base..value)
      paragraphs.join("\n\n")
    end

    def name
      NAMES[rand(10)]
    end

    def title
      verb = VERBS[rand(55)]
      adj =  ADJECTIVES[rand(63)]
      noun = NOUNS[rand(42)]
      bs = "#{verb} #{adj} #{noun}"
      bs.titleize
    end
  end
end

# Seed code
user = User.create(:username => 'system', :password => 'system', :password_confirmation => 'system',
                   :email => 'system@junk.com')

blog = user.blogs.create(:title => 'System User Blog', :tagline => SeedUtils.title, :author => 'Alvin Smith',
                         :detail => SeedUtils.greek_paragraph, :bio => "About me.")

SeedUtils.create_post blog, 3

user = User.create(:username => 'demo', :password => 'demo', :password_confirmation => 'demo', :email => 'demo@junk.com')

blog = user.blogs.build(:title => 'Email Etiquette', :tagline => SeedUtils.title, :author => 'SB',
                        :detail => SeedUtils.greek_paragraph, :bio => "About me.");

file = File.open(Rails.root.join('public', 'images', 'sb.jpg'), "rb")
blog.byte_content = file.read
blog.save

SeedUtils.create_post blog, 4

blog = user.blogs.create(:title => 'RubyAMF greek and more', :tagline => SeedUtils.title, :author => 'HR',
                         :detail => SeedUtils.greek_paragraph, :bio => "About me.");

file = File.open(Rails.root.join('public', 'images', 'hr.jpg'), "rb")
blog.byte_content = file.read
blog.save

SeedUtils.create_post blog, 5