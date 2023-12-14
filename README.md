# MAOBI

Maobi is an app for beginners interested in Chinese calligraphy, and it teaches users Chinese calligraphy by providing feedback to users’ work using an image processing algorithm. Unlike most Chinese calligraphy apps, Maobi serves to help users with physical brush-writing (as opposed to just using a touch screen), and displays visual feedback on where exactly the user can improve upon. “Maobi” is the Chinese word for the calligraphy brush.

## Setup
The login page is prefilled with the username and password of our "sample user," so you can just click "Login." Alternatively, you may create a new user in the app with a different username. The tutorial will automatically appear for new users, so if you use the "sample user," you can re-access the tutorial from the hamburger menu. When the app prompts you to take a photo of your submission during a level, you can point your camera at one of the characters in our "submissions.jpg" sample in this repository. 

## Key features and design decisions:

-   Camera feedback: Processes a 2D image of the user’s finished work of a single character or stroke, compares it with a “correct” image, and provides visual feedback with parts that need improvement highlighted in red. Because beginners are often unable to recognize mistakes when learning a new skill on their own, we wanted to visually show users exactly where they could improve.
    
-   Paper alignment: Because it’s difficult to get a perfect photo to compare with due to angles, we designed and implemented a way to align the user’s image with a template image through rotating, resizing, and panning
    
-   Currency system & in-app purchases: We designed and developed a currency system of stars, where users could earn stars based on how well they complete a level, or through in-app purchases. Players use these stars to unlock more characters. This motivates players to practice and do well on levels, and also is a way to generate revenue from the app, through the In-App purchases page.
    
-   8 basic strokes, Characters, and Extra Packs: Players learn and receive feedback of the 8 basic strokes, which are the fundamentals of Chinese calligraphy, as well as some basic characters and extra specialty packs. Each “level” has the user take a picture of their calligraphy work for that stroke and receive camera feedback on it. Because we wanted users to master the basic strokes first, we locked characters until the 8 basic strokes were completed. The extra packs are currently not fully implemented as we did not deem it as a necessary feature since it is simply an extension of character content.
    
-   Daily Challenge & Streaks: As an incentive to return to the app, we designed and implemented a daily challenge and “streak” system for users to do everyday. This would also automatically unlock the character in the challenge once completed.
    
-   Onboarding & Tutorial: We created an interactive onboarding process where the user could trace a Chinese character and see it get drawn on the screen as a means to draw the user into the app. We also added a navigation tutorial to introduce the different features of the app so the user could easily understand where everything is. In the case that the user wants to revisit these, we added a way to go back to the onboarding and tutorial screens.
  

## Testing

We reached 92.3% test coverage through our test cases. We excluded views and previews from our testing coverage, because we are not able to test the act of taking a picture. However, we tested all models. This includes Firebase tests with delays, User data functions, data of Chinese characters, content within the levels, functions that generate and transform photos, and the feedback algorithm.


## Technical Decisions

The most technical aspects of our application were the paper alignment and the feedback algorithm when providing feedback to the user. We initially wanted to be able to transform the perspective of the paper (similar to paper scanning apps), but we ran into several technical issues with the current perspective transformation tools available for Swift. We tried several options, the most popular of which was AGGeometryKit, but there was a lack of documentation and incompatibility with our version of Xcode/Swift/ios. As a result, we switched from our initial plans of a freeform perspective transformation to a tool that handles rotation, translation, and zooming.

Our feedback algorithm calculates thickness by the proportion of a sample of the submitted image’s points that are contained inside the template’s points outline. So for example, if almost all of the submitted image’s points are inside then it must be too thin, or if they’re mostly outside, then it must be too thick. We account for a moderate margin of error as a percentage of the points compared. In some situations, poor alignment interferes with the thickness calculation, so a future improvement could be to compare areas as opposed to points.

Our feedback algorithm calculates alignment by comparing the bounding boxes in the x & y directions separately. It can provide feedback about the alignment of the left side, right side, top, and bottom of each stroke in comparison to the same characteristics of the strokes in the template. This also accounts for a margin of error in terms of an “acceptable” distance between the submission and template alignments. Occasionally, the thickness calculation also interferes with the alignment by making certain strokes seem more tilted than they actually are. So another future improvement could be to apply a skeleton thinning algorithm and compare the center lines of strokes as opposed to their bounding boxes.
