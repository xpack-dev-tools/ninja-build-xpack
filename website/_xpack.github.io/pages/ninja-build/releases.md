---

title: The xPack Ninja Build releases
permalink: /dev-tools/ninja-build/releases/

search: exclude
github_editme: false

comments: false
toc: false

date: 2020-09-28 17:53:00 +0300

redirect_to: https://xpack-dev-tools.github.io/ninja-build-xpack/docs/releases/

---

___
{% for post in site.posts %}{% if post.categories contains "releases" %}{% if post.categories contains "ninja-build" %}
* [{{ post.title }}]({{ site.baseurl }}{{ post.url }}) [(download)]({{ post.download_url }}){% endif %}{% endif %}{% endfor %}
