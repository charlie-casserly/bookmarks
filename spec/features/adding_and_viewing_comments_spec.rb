feature 'Adding and viewing comments' do 
  scenario 'a comment is added to bookmark' do 
    bookmark = Bookmark.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')

    visit('/bookmarks')
    expect(page).to have_content 'Makers Academy'
    first('.bookmark').click_button 'Add Comment'
    expect(current_path).to eq "/bookmarks/#{bookmark.id}/comments/new"

    fill_in 'comment', with: 'This is a test comment'
    click_button 'Submit'

    expect(current_path).to eq('/bookmarks')
    expect(first('.bookmark')).to have_content 'This is a test comment'
  end
end

