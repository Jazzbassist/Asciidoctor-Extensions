#!/bin/ruby
for filename in ["inline_anchor", "inline_break", "inline_button", "inline_callout", "inline_footnote", "inline_image", "inline_indexterm", "inline_kbd", "inline_menu", "inline_quoted"] #"block_admonition", "block_audio", "block_colist", "block_dlist", "block_example", "block_floating", "block_image", "block_listing", "block_literal", "block_math", "block_olist", "block_page_break", "block_pass", "block_preamble", "block_quote", "block_ruler", "block_sidebar", "block_table", "block_tox", "block_ulist", "block_verse", "block_video", "embedded", 
	f=File.open("#{filename}.erb", "w+")
	f.write(
%(  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {},
   "outputs": [],
   "source": [
    print("#{filename}")
   ]
  },))
end
