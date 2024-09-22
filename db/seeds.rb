# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

prompt = Prompt.create(text: 'Shall I compare thee to a summer’s day? Thou art more lovely and more temperate:', author: 'William Shakespeare')
Response.create(text: 'Rough winds do shake the darling buds of May, And summer’s lease hath all too short a date;', prompt_id: prompt.id, correct: true)

prompt = Prompt.create(text: 'Because I could not stop for Death— He kindly stopped for me—', author: 'Emily Dickinson')
Response.create(text: 'The Carriage held but just Ourselves— And Immortality.', prompt_id: prompt.id, correct: true)

prompt = Prompt.create(text: 'She walks in beauty, like the night Of cloudless climes and starry skies;', author: 'Lord Byron')
Response.create(text: 'And all that’s best of dark and bright Meet in her aspect and her eyes;', prompt_id: prompt.id, correct: true)

prompt = Prompt.create(text: 'O Captain! my Captain! our fearful trip is done, The ship has weather’d every rack, the prize we sought is won,', author: 'Walt Whitman') 
Response.create(text: 'The port is near, the bells I hear, the people all exulting,', prompt_id: prompt.id, correct: true)

prompt = Prompt.create(text: 'Two roads diverged in a yellow wood, And sorry I could not travel both', author: 'Robert Frost')  
Response.create(text: 'And be one traveler, long I stood And looked down one as far as I could', prompt_id: prompt.id, correct: true)

prompt = Prompt.create(text: 'Hold fast to dreams For if dreams die', author: 'Langston Hughes')
Response.create(text: 'Life is a broken-winged bird That cannot fly.', prompt_id: prompt.id, correct: true)

prompt = Prompt.create(text: 'Once upon a midnight dreary, while I pondered, weak and weary, Over many a quaint and curious volume of forgotten lore—', author: 'Edgar Allan Poe')  
Response.create(text: 'While I nodded, nearly napping, suddenly there came a tapping, As of some one gently rapping, rapping at my chamber door.', prompt_id: prompt.id, correct: true)

prompt = Prompt.create(text: 'I wandered lonely as a cloud That floats on high o’er vales and hills,', author: 'William Wordsworth')  
Response.create(text: 'When all at once I saw a crowd, A host, of golden daffodils;', prompt_id: prompt.id, correct: true)

prompt = Prompt.create(text: 'The woods are lovely, dark and deep, But I have promises to keep,', author: 'Robert Frost')
Response.create(text: 'And miles to go before I sleep, And miles to go before I sleep.', prompt_id: prompt.id, correct: true)
