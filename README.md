Even though this is a small project with only three screens, I wanted to implement clean architecture. 

Almost every project starts with a couple of screens and can scale to a much larger app, and that’s why I believe it’s important to set up a good architecture that can be scaled without major refactoring. 
Clean architecture structures a project into independent layers, allowing us to update each without disrupting others. For example, if we wanted to make this app for iPads, we would just update Presentation (UI) layer, 
without making changes to the business logic or repositories from which the data is fetched. Another example, if we wanted to introduce storing data in a local database for offline use, 
we wouldn’t have to make any changes to our business logic, we could just add a new repository from which the data is fetched.

Having clear boundaries between layers makes the project easier to test, update and scale, and that is why my aim was to make this project as modular as possible, ensuring maximum flexibility.
