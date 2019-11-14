---
layout: page
title: Anne Sexton, Woodberry, 1974
permalink: /1/
---

Universal Viewer Goes Here

| Time                  | Annotation |
| --------------------- | ---------- |
{% for anno_files in site.data.1 -%}
{{ anno_files | inspect }}
	{% assign annos = anno_files[1] -%}
	{% for annotation in annos.items -%}
		| {{ annotation.target.selector.t }} | {{ annotation.body.value }} |
	{% endfor %}
 {%- endfor -%}

{% assign static_files = site.static_files | where: file.path, true %}

{% for myfile in static_files %}
  [ {{ myfile.path }} ]( {{ myfile.path }} )
{% endfor %}
