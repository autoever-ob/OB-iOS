
Search
Write
Sign up

Sign in



OLX Engineering
OLX Engineering
OLX is a global leader in facilitating trade. It builds leading marketplace ecosystems enabled by tech, powered by trust, and loved by its customers.

Follow publication

Clean Architecture and MVVM on iOS
Oleh Kudinov
Oleh Kudinov

Follow
10 min read
·
Aug 22, 2019
4.3K


26



Press enter or click to view image in full size

Photo by Joel Filipe on Unsplash
When we develop software it is important to not only use design patterns, but also architectural patterns. There are many different architectural patterns in Software Engineering. In mobile software engineering, the most widely used are MVVM, Clean Architecture and Redux patterns.

In this article, we will show on a working example project how architectural patterns MVVM and Clean Architecture can be applied in an iOS app.

If you are also interested in learning about Redux, check out this book: Advanced iOS App Architecture.

More information about Clean Architecture.

Press enter or click to view image in full size

As we can see in Clean Architecture graph, we have different layers in the application. The main rule is not to have dependencies from inner layers to outers layers. The arrows pointing from outside to inside is the Dependency rule. There can only be dependencies from outer layer inward.

After grouping all layers we have: Presentation, Domain and Data layers.

Press enter or click to view image in full size

Domain Layer (Business logic) is the inner-most part of the onion (without dependencies to other layers, it is totally isolated). It contains Entities(Business Models), Use Cases, and Repository Interfaces. This layer could be potentially reused within different projects. Such separation allows for not using the host app within the test target because no dependencies (also 3rd party) are needed — this makes the Domain Use Cases tests take just a few seconds. Note: Domain Layer should not include anything from other layers(e.g Presentation — UIKit or SwiftUI or Data Layer — Mapping Codable)

The reason that good architecture is centered around Use Cases is so that architects can safely describe the structures that support those Use cases without committing to frameworks, tools, and environment. It is called Screaming Architecture.

Presentation Layer contains UI (UIViewControllers or SwiftUI Views). Views are coordinated by ViewModels (Presenters) which execute one or many Use Cases. Presentation Layer depends only on the Domain Layer.

Data Layer contains Repository Implementations and one or many Data Sources. Repositories are responsible for coordinating data from different Data Sources. Data Source can be Remote or Local (for example persistent database). Data Layer depends only on the Domain Layer. In this layer, we can also add mapping of Network JSON Data (e.g. Decodable conformance) to Domain Models.

On the graph below every component from each layer is represented along with Dependency Direction and also the Data flow (Request/Response). We can see the Dependency Inversion point where we use Repository interfaces(protocols). Each layer’s explanation will be based on the example project mentioned at the beginning of the article.

Press enter or click to view image in full size

Data Flow
1. View(UI) calls method from ViewModel (Presenter).

2. ViewModel executes Use Case.

3. Use Case combines data from User and Repositories.

4. Each Repository returns data from a Remote Data (Network), Persistent DB Storage Source or In-memory Data (Remote or Cached).

5. Information flows back to the View(UI) where we display the list of items.

Dependency Direction
Presentation Layer -> Domain Layer <- Data Repositories Layer

Presentation Layer (MVVM) = ViewModels(Presenters) + Views(UI)

Domain Layer = Entities + Use Cases + Repositories Interfaces

Data Repositories Layer = Repositories Implementations + API(Network) + Persistence DB

Example Project: "Movies App"
Press enter or click to view image in full size

Domain Layer
Inside the example project you can find Domain Layer. It contains Entities, SearchMoviesUseCase which searches movies and stores recent successful queries. Also, it contains Data Repositories Interfaces which are needed for Dependency Inversion.


Note: Another way to create Use Cases is to use UseCase protocol with start() function and all use cases implementations will conform to this protocol. One of use cases in the example project follows this approach: FetchRecentMovieQueriesUseCase. Use Cases are also called Interactors

Note: A UseCase can depend on other UseCases

Presentation Layer
Presentation Layer contains MoviesListViewModel with items that are observed from the MoviesListView. MoviesListViewModel does not import UIKit. Because keeping the ViewModel clean from any UI frameworks like UIKit, SwiftUI or WatchKit will allow for easy reuse and refactor. For example in future the Views refactor from UIKit to SwiftUI will be much easier, because the ViewModel will not need to change.


Note: We use interfaces MoviesListViewModelInput and MoviesListViewModelOutput to make MoviesListViewController testable, by mocking ViewModel easily(example). Also, we have MoviesListViewModelActions closures, which tells to MoviesSearchFlowCoordinator when to present another views. When action closure is called coordinator will present movie details screen. We use a struct to group actions because we can add later easily more actions if needed.

Presentation Layer also contains MoviesListViewController which is bound to data(items) of MoviesListViewModel.

UI cannot have access to business logic or application logic (Business Models and UseCases), only ViewModels can do it. This is the separation of concerns. We cannot pass business models directly to the View (UI). This why we are mapping Business Models into ViewModel inside ViewModel and pass them to the View.

We also add a search event call from the View to ViewModel to start searching movies:


Note: We observe items and reload view when they change. We use here a simple Observable, which is explained in MVVM section below.

We also assign function showMovieDetails(movie:) to Actions of MoviesListViewModel inside MoviesSearchFlowCoordinator, to present movie details screens from flow coordinator:


Note: We use Flow Coordinator for presentation logic, to reduce View Controllers’ size and responsibility. We have strong reference to Flow (with action closures, self functions) to keep Flow not deallocated while is needed.

With this approach, we easily can use different views with the same ViewModel without modifying it. We could just check if iOS 13.0 is available and then create a SwiftUI View instead of UIKit and bind it to the same ViewModel otherwise we create UIKit View. In the example project I also added SwiftUI example for MoviesQueriesSuggestionsList. At least Xcode 11 Beta is required.


Data Layer
Data Layer contains DefaultMoviesRepository. It conforms to interfaces defined inside Domain Layer (Dependency Inversion). We also add here the mapping of JSON data(Decodable conformance) and CoreData Entities to Domain Models.


Note: Data Transfer Objects DTO is used as intermediate object for mapping from JSON response into Domain. Also if we want to cache endpoint response we would store Data Transfer Objects in persistent storage by mapping them into Persistent objects(e.g. DTO -> NSManagedObject).

In general Data Repositories can be injected with API Data Service and with Persistent Data Storage. Data Repository works with these two dependencies to return data. The rule is to first ask persistent storage for cached data output (NSManagedObject are mapped into Domain via DTO object, and retrieved in cached data closure). Then to call API Data Service which will return the latest updated data. Then Persistent Storage is updated with this latest data (DTOs are mapped into Persistent Objects and saved). And then DTO is mapped into Domain and retrieved in updated data/completion closure. This way users will see the data instantaneously. Even if there is no internet connection, users still will see the latest data from Persistent Storage. example

The storage and API can be replaced by totally different implementations (from CoreData to Realm for example). While all the rest layers of the app will not be affected by this change, this is because DB is a detail.

Infrastructure Layer (Network)
It is a wrapper around network framework, it can be Alamofire (or another framework). It can be configured with network parameters (for example base URL). It also supports defining endpoints and contains data mapping methods (using Decodable).


Note: You can read more here: https://github.com/kudoleh/SENetworking

MVVM
The Model-View-ViewModel pattern (MVVM) provides a clean separation of concerns between the UI and Domain.

When used together with Clean Architecture it can help to separate concerns between Presentation and UI Layers.

Get Oleh Kudinov’s stories in your inbox
Join Medium for free to get updates from this writer.

Enter your email
Subscribe
Different view implementations can be used with the same ViewModel. For example, you can use CarsAroundListView and CarsAroundMapView and use CarsAroundViewModel for both. You can also implement one View UIKit and another View with SwiftUI. It is important to remember to not import UIKit, WatchKit and SwiftUI inside your ViewModel. This way it could be easily reused in other platforms if needed.

Press enter or click to view image in full size

Data Binding between View and ViewModel can be done for example with closures, delegates or observables (e.g. RxSwift). Combine and SwiftUI also can be used but only if your minimum supported iOS system is 13. The View has a direct relationship to ViewModel and notifies it whenever an event inside View happens. From ViewModel, there is no direct reference to View (only Data Binding)

In this example, we will use a simple combination of Closure and didSet to avoid third-party dependencies:


Note: This is a very simplified version of Observable, to see the full implementation with multiple observers and observer removal: Observable.

An example of data binding from ViewController:


Note: Accessing viewModel from observing closure is not allowed, it causes a retain cycle(memory leak). You can access viewModel only with self: self?.viewModel.

An example of data binding on TableViewCell (Reusable Cell):


Note: We have to unbind if the view is reusable (e.g. UITableViewCell)

MVVM Templates can be found here

MVVMs Communication
Delegation
ViewModel of one MVVM(screen) communicates with another ViewModel of another MVVM(screen) using delegation pattern:

Press enter or click to view image in full size

For example, we have ItemsListViewModel and ItemEditViewModel. Then we create a protocol ItemEditViewModelDelegate with method ItemEditViewModelDidEditItem(item). And we make it conform to this protocol: extension ListItemsViewModel: ItemEditViewModelDelegate

Note: We can also name Delegates in this case as Responders: ItemEditViewModelResponder

Closures
Another way to communicate is by using closures which are assigned or injected by FlowCoordinator. In the example project we can see how MoviesListViewModel uses action closure showMovieQueriesSuggestions to show the MoviesQueriesSuggestionsView. It also passes parameter (_ didSelect: MovieQuery) -> Void so it can be called back from that View. The communication is connected inside MoviesSearchFlowCoordinator:

Layer Separation into frameworks (Modules)
Now each layer (Domain, Presentation, UI, Data, Infrastructure Network) of the example app can be easily separated into separate frameworks.

New Project -> Create Project… -> Cocoa Touch Framework
Then you can include these frameworks into your main app by using CocoaPods. You can see this working example here. Note: you will need to delete ExampleMVVM.xcworkspace and run pod install to generate a new one, because of a permission issue.

Press enter or click to view image in full size
Press enter or click to view image in full size
Dependency Injection Container
Dependency injection is a technique whereby one object supplies the dependencies of another object. DIContainer in your application is the central unit of all injections.

Using dependencies factory protocols

One of the options is to declare a dependencies protocol that delegates the creation of dependency to DIContainer. To do this we need to define MoviesSearchFlowCoordinatorDependencies protocol and make your MoviesSceneDIContainer to conform to this protocol, and then inject it into the MoviesSearchFlowCoordinator that needs this injection to create and present MoviesListViewController. Here are the steps:

Using closures

Another option is to use closures. To do it we need to declare closure inside the class that needs an injection and then we inject this closure. For example:

Source code
kudoleh/iOS-Clean-Architecture-MVVM
iOS Project implemented with Clean Layered Architecture and MVVM. (Can be used as Template project by replacing item…
github.com

Companies with many iOS Engineers
Clean Architecture + MVVM is successfully used at fintech company Revolut with >70 iOS engineers.

Resources
Advanced iOS App Architecture

The Clean Architecture

The Clean Code

Conclusion
The most used architectural patterns in mobile development are Clean Architecture(Layered), MVVM, and Redux.

MVVM and Clean Architecture can be used separately of course, but MVVM provides separation of concerns only inside the Presentation Layer, whereas Clean Architecture splits your code into modular layers that can be easily tested, reused, and understood.

It is important to not skip creation of a Use Case, even if the Use Case does nothing else besides calling Repository. This way, your architecture will be self-explanatory when a new developer sees your Use cases.

Although this should be useful as a starting point, there are no silver bullets. You pick the architecture that fulfills your needs in the project.

Clean Architecture works really good with (Test Driven Development) TDD. This architecture makes the project testable and layers can be replaced easily (UI and Data).

Domain-Driven Design (DDD) also works very well with Clean Architecture (CA).

In software development there are more different architectures interesting to know: The 5 Patterns You Need to Know

More software engineering best practices:

Do not write code without tests (try TDD)
Do continuous refactoring
Do not over-engineer and be pragmatic
Avoid using third-party framework dependencies in your project as much as you can
More on Mobile Architecture topic
Modular Architecture
How can you improve your project by decoupling your app into totally isolated modules (e.g. NetworkingService, TrackingService, ChatFeature, PaymentFeature…)? And how can all teams work with these modules rapidly and independently 🤔?

Check out the tech article about Modular Architecture: modularisation of the app

Modular Architecture in iOS
In the previous article, we have seen how to create an app using Clean Architecture + MVVM. Here we show how to improve…
tech.olx.com

IOS
Mvvm
Swift
Clean Architecture
Software Architecture
4.3K


26


OLX Engineering
Published in OLX Engineering
2.7K followers
·
Last published Sep 9, 2025
OLX is a global leader in facilitating trade. It builds leading marketplace ecosystems enabled by tech, powered by trust, and loved by its customers.


Follow
Oleh Kudinov
Written by Oleh Kudinov
770 followers
·
84 following

Follow
Responses (26)

Write a response

What are your thoughts?

Cancel
Respond
See all responses
More from Oleh Kudinov and OLX Engineering
Modular Architecture in iOS
OLX Engineering
In

OLX Engineering

by

Oleh Kudinov

Modular Architecture in iOS
In the previous article, we have seen how to create an app using Clean Architecture + MVVM. Here we show how to improve your project by…
Dec 18, 2019
1.5K
16
Hybrid Search — Where Keywords Meet Vectors, Enabling Classifieds Discovery
OLX Engineering
In

OLX Engineering

by

Inês Soveral

Hybrid Search — Where Keywords Meet Vectors, Enabling Classifieds Discovery
In the midst of a fast-paced technological revolution, where user expectations grow increasingly sophisticated, the quality of search in…
Sep 10
54
1
Photo by Rosy Ko
OLX Engineering
In

OLX Engineering

by

Jordi Esteve Sorribas

Scaling recommendations service at OLX
In distributed systems, there is a motto that says ‘you are as slow as your slowest tasks’. In Python, thanks to the notorious Global…
Jul 9
22
From RankNet to LambdaMART: Leveraging XGBoost for Enhanced Ranking Models
OLX Engineering
In

OLX Engineering

by

Enderson Santos

From RankNet to LambdaMART: Leveraging XGBoost for Enhanced Ranking Models
In the ever-evolving world of machine learning, the journey from theory to application can be both fascinating and complex. This article…
Feb 11
41
See all from Oleh Kudinov
See all from OLX Engineering
Recommended from Medium
Modern iOS architecture patterns diagram featuring Unidirectional Data Flow, Composition-Based Architecture, Modular Monoliths, and Observable Pattern with connecting arrows
Ravi
Ravi

Beyond MVVM: Exploring the Future of iOS Architecture
Unlock the next generation of iOS app architecture patterns that top developers are already using to build faster, more maintainable apps…

Sep 11
21 SwiftUI Interview Questions Every iOS Developer Should Master (With Code Examples)
Kumar Gaurav
Kumar Gaurav

21 SwiftUI Interview Questions Every iOS Developer Should Master (With Code Examples)
Two months ago, I sat across from an iOS recruiter who smiled and said, “Let’s start with SwiftUI.”

Aug 11
337
1
[SwiftUI] Building a To‑Do App with MVVM + Clean Architecture
Yohei Okawa
Yohei Okawa

[SwiftUI] Building a To‑Do App with MVVM + Clean Architecture
In this article, I focus on SwiftUI and Clean Architecture, distilling my architectural insights into a cohesive write‑up. Drawing on…
Apr 20
1
SwiftUI Performance Optimization: Why Your App is Slow (And How to Fix It)
Utsav Patel
Utsav Patel

SwiftUI Performance Optimization: Why Your App is Slow (And How to Fix It)
Part 3 of 4 | Day 2: Performance & Testing | 5 min read

Aug 29
11
SOLID Principles in Swift Made Easy (With Real-Life Examples)
Swift Pal
In

Swift Pal

by

Karan Pal

SOLID Principles in Swift Made Easy (With Real-Life Examples)
A beginner-friendly guide to SOLID principles in Swift — packed with code examples and real-world use cases🤓🔥

Jun 15
116
SwiftData Architecture — Patterns and Practices
Stackademic
In

Stackademic

by

Mohammad Azam

SwiftData Architecture — Patterns and Practices
SwiftData, announced at WWDC 2023, marks a significant evolution in data persistence for SwiftUI applications. Built from the ground up…

Apr 27
26
1
See more recommendations
Help

Status

About

Careers

Press

Blog

Privacy

Rules

Terms

Text to speech

