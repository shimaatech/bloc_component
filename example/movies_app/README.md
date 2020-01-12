# example

An example of using the bloc_component library

## Getting Started

This example demonstrates how to use the bloc_component library by building a simple app
for showing a movies list and adding them to favorite list. For more info please refer to the 
library [repository] or to the [docs]

**The app is fully documented, so that there is almost no need to explain anything here**.


![Movies App demo](https://media.giphy.com/media/eIyX1CUFzQkgjV8IMG/giphy.gif)


## App contents

**The app contains 2 pages**:
- Movies Page: Shows a list of all the available movies in the repository with the ability to add
movies to the favorite list and to filter them according to the genre.
- Favorite Movies Page: Shows the favorite movies with the ability to remove them from the favorite
list

**The app contains 4 `Components`**:
- A Component for the `Movies Page`
- A Component for the `Favorite Movies Page`
- A Component for the `App Home` (A home page wrapper)
- A shared component (`MovieItem`) that is used by both the `Movies Page` and the `Favorite Movies Page`
 
