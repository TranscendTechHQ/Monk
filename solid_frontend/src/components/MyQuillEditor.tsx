import { Component, createSignal, onMount } from 'solid-js';
import Quill from 'quill';
import 'quill/dist/quill.snow.css';
//import quillEmoji from 'quill-emoji';

export const QuillEditor: Component = () => {
  let editorRef: HTMLDivElement | undefined;
  const [quill, setQuill] = createSignal<Quill | null>(null);

  onMount(() => {
    if (editorRef) {
      const quillInstance = new Quill(editorRef, {
        theme: 'snow',
        modules: {
          toolbar: [
            ['bold', 'italic', 'underline', 'strike'],
            ['blockquote', 'code-block'],
            
            [{ 'header': 1 }, { 'header': 2 }],
            [{ 'list': 'ordered' }, { 'list': 'bullet' }],
            [{ 'script': 'sub' }, { 'script': 'super' }],
            [{ 'indent': '-1' }, { 'indent': '+1' }],
            [{ 'direction': 'rtl' }],
            [{ 'size': ['small', false, 'large', 'huge'] }],
            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
            [{ 'color': [] }, { 'background': [] }],
            [{ 'font': [] }],
            [{ 'align': [] }],
            ['clean']
          ]
        }
      });
      setQuill(quillInstance);
    }
  });

  return (
    <div class="w-full max-w-4xl mx-auto p-4">
      <div class="bg-white shadow-lg rounded-lg overflow-hidden">
        <div class="p-4">
          <div 
            ref={editorRef} 
            class="min-h-[200px] focus:outline-none"
          />
        </div>
      </div>
    </div>
  );
};



