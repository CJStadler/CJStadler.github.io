---
layout: post
title: Struggling to understand frames in turbo-rails
---


## Inefficient

Endpoints return data that is discarded by the frontend. It seems like such an obvious inefficiency that there must be something I’m missing. Is it better for caching to render the whole page? Are you intended to design your routes and controllers in such a way that this has minimal impact?

I think you can solve this by putting each frame into its own partial and only rendering the partial for the requested frame:

```rb
if turbo_frame_request_id == "my_frame"
  render "_my_frame"
end
```

But I’m surprised turbo-rails doesn’t make this easier.

For example, there could be a naming convention for partials containing frames, and turbo-rails could render them automatically:

```rb
def render_frame
  if turbo_frame_request_id
    render "frames/_#{turbo_frame_request_id}"
  end
end
```

## Code duplication and coupling

```html
<turbo-frame id="books">
  <ul>
    <li><a href="/books/1">Book 1</a></li>
    <li><a href="/books/2">Book 2</a></li>
  </ul>
</turbo-frame>
```

The intention of this code is that clicking either link will display the corresponding book inside of the `books` frame. But this only works if `/books/1` returns a frame with `id="books"`. If it does not there is no sane fallback (like navigating the whole page), you just get an error.

This means that an endpoint can't be re-used for different frames.

This can be solved by programmatically wrapping the response in a `turbo-frame` with the `id` of the requested frame. This might not be desired for all endpoints, but `turbo-rails` could provide a way to enable this.

## Interface duplication

In the above example clicking the `/books/1` link will update the `books` frame to show the corresponding frame from that endpoint. But if you open the link in a new tab or window you will see the whole `/books/1` page. This is arguably better than in many Javascript-based applications where you can't open links in new tabs at all. But now there are two ways for users to see the same information. Two views that need to be designed, tested, maintained, etc..

## When should turbo frames be used?

When you expect each endpoint to primarily be displayed as its own full page, but also want to allow some of it to be embedded. For example, to show a "preview" of an individual resource in a table.

This doesn't seem like a very common situation. I expect that in most apps the "full" page instead gets ignored. For example, on [https://www.hotrails.dev/quotes](https://www.hotrails.dev/quotes) if you open many of the pages in new tabs they are functional, but feel incomplete.

- `/quotes/new` lets you create a new quote, but after saving you see a blank page. The intention is to create a new quote from the `/quotes` page, where the created quote would be displayed in the table.
- `/line_items/:id/edit` shows the editor for the item, but it's missing any information about the quote that the item belongs to, since the intention is for the editor to be shown as part of the quote page itself.

Are turbo frames mainly intended as a transitional step, or as a small enhancement on top of a "normal" Rails app, rather than a foundational tool?
