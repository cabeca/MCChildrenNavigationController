Pod::Spec.new do |s|
  s.name         = "MCChildrenNavigationController"
  s.version      = "0.0.9"
  s.summary      = "MCChildrenNavigationController displays tree structures in a navigation interface"

  s.description  = <<-DESC
                    MCChildrenNavigationController displays tree structures in a navigation interface                    
                   DESC

  s.homepage     = "https://github.com/cabeca/MCChildrenNavigationController"
  s.license      = 'MIT'
  s.author       = { "Miguel Cabeça" => "miguel.cabeca@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/cabeca/MCChildrenNavigationController.git", :tag => s.version }
  s.source_files = 'MCChildrenNavigationController/lib/*.{h,m}'
  s.requires_arc = true
end
