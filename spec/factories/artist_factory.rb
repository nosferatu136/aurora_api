Factory.define(:artist) do |a|
  a.sequence(:name) do |n|
    titles = ["Joe Satriani", "Kerry King", "Jimmy Page"]
    titles[n % titles.length]
  end
  a.bio "Now, this is the story all about how\nMy life got flipped-turned upside down\n" \
        "And I'd like to take a minute\nJust sit right there\n" \
        "I'll tell you how I became the prince of a town called Bel Air\n\n" \
        "In west Philadelphia born and raised\nOn the playground was where I spent most of my days\n" \
        "Chillin' out maxin' relaxin' all cool\nAnd all shootin some b-ball outside of school\n" \
        "When a couple of guys\nWho were up to no good\nStartin making trouble in my neighborhood\n" \
        "I got in one little fight and my mom got scared\n" \
        "She said 'You're movin' with your auntie and uncle in Bel Air'\n\n" \
        "I begged and pleaded with her day after day\nBut she packed my suite case and sent me on my way\n" \
        "She gave me a kiss and then she gave me my ticket.\n" \
        "I put my walkman on and said, 'I might as well kick it'.\n\n" \
        "First class, yo this is bad\nDrinking orange juice out of a champagne glass.\n" \
        "Is this what the people of Bel-Air living like?\nHmmmmm this might be alright.\n\n" \
        "But wait, I hear the prissy, booze, whine, all that\n" \
        "Is this the type of place that they should send this cool cat?\nI don't think so\n" \
        "I'll see when I get there\nI hope they're prepared for the prince of Bel-Air\n\n" \
        "Well uh, the plane landed and when I came out\n" \
        "There was a dude who looked like a cop standing there with my name out\n" \
        "I ain't trying to get arrested yet.\nI just got here!\nI sprang with the quickness, " \
        "like lightening disappeared\n\nI whistled for a cab and when it came near\n" \
        "The license plate said fresh and it had dice in the mirror\nIf anything I can say is that" \
        " this cab was rare\nBut I thought 'Man forget it' - 'Yo home to Bel Air'\n\n" \
        "I pulled up to the house about seven or eight\nAnd I yelled to the cabbie 'Yo homes smell ya later'\n" \
        "I looked to my kingdom\nI was finally there\nTo sit on my throne as the Prince of Bel Air"
  a.alias 'The Doc'
end
