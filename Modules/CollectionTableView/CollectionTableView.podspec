Pod::Spec.new do |s|
    s.name         = "CollectionTableView"
    s.version      = "0.1.0"
    s.summary      = "A brief description of CollectionTableView project."
    s.description  = <<-DESC
    An extended description of CollectionTableView project.
    DESC
    s.homepage     = "http://www.github.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2021
                   Permission is granted to...
                  LICENSE
                }
    s.author             = { "$(git config user.name)" => "$(git config user.email)" }
    s.source       = { :git => "file://////Users/Fabio Silvestri/Developer/pod/frameworks/git/CollectionTableView.git", :tag => "#{s.version}" }
    s.source_files  = "CollectionTableView/**/*.swift"
    s.resources = "CollectionTableView/**/*.storyboard"
    s.platform = :ios
    s.swift_version = "4.2"
    s.ios.deployment_target  = '11.0'
    s.dependency 'DinoComponents', '~> 0.1.0'
    s.dependency 'DinoData', '~> 0.1.0'
end

