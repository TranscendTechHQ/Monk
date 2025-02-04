import { Component, Show, createSignal } from 'solid-js';
import { ThreadsService } from '../api/services/ThreadsService';

interface NewThreadModalProps {
  show: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

const NewThreadModal: Component<NewThreadModalProps> = (props) => {
  const [topic, setTopic] = createSignal('');
  const [text, setText] = createSignal('');
  const [image, setImage] = createSignal<File | null>(null);
  const [imagePreview, setImagePreview] = createSignal<string | null>(null);
  const [isCreating, setIsCreating] = createSignal(false);

  const handleCreateThread = async () => {
    if (!topic().trim() && !text().trim() && !image()) return;

    let imageKey: string | null = null;

    try {
      setIsCreating(true);
      
      if (image()) {
        imageKey = image()!.name;
        const url = await ThreadsService.getUploadUrl(imageKey);
        
        const uploadResponse = await fetch(url, {
          method: 'PUT',
          body: image(),
          headers: { 'Content-Type': image()!.type },
        });

        if (!uploadResponse.ok) {
          throw new Error('Image upload failed');
        }
      }

      await ThreadsService.createThread({
        topic: topic(),
        text: text(),
        image: imageKey || undefined
      });

      setTopic('');
      setText('');
      setImage(null);
      setImagePreview(null);
      props.onSuccess();
      props.onClose();
    } catch (err) {
      console.error('Error creating thread:', {
        error: err,
        requestDetails: {
          topic: topic(),
          text: text(),
          imageKey,
          imageSize: image()?.size
        }
      });
      alert('Failed to create thread. Please check the console for details.');
    } finally {
      setIsCreating(false);
    }
  };

  return (
    <Show when={props.show}>
      <div class="fixed inset-0 bg-monk-dark/90 backdrop-blur-sm flex items-center justify-center p-4 z-50">
        <div class="bg-monk-blue/90 backdrop-blur-lg rounded-xl p-6 w-full max-w-2xl">
          {/* Modal header */}
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-monk-cream text-xl font-bold">Create New Thread</h3>
            <button
              onClick={props.onClose}
              class="text-monk-gray hover:text-monk-gold transition-colors"
            >
              ✕
            </button>
          </div>

          {/* Form content */}
          <div class="space-y-4">
            <input
              type="text"
              value={topic()}
              onInput={(e) => setTopic(e.currentTarget.value)}
              placeholder="Thread Topic"
              class="w-full bg-monk-dark text-monk-cream p-3 rounded-lg border border-monk-teal/40 focus:outline-none focus:border-monk-teal"
            />

            <div class="flex items-center gap-2 border border-monk-teal/40 rounded-lg p-2">
              <label class="cursor-pointer text-monk-gray hover:text-monk-gold transition-colors">
                <input
                  type="file"
                  accept="image/*"
                  class="hidden"
                  onChange={(e) => {
                    const file = e.currentTarget.files?.[0];
                    if (file) {
                      setImage(file);
                      setImagePreview(URL.createObjectURL(file));
                    }
                  }}
                />
                📎
              </label>

              <textarea
                value={text()}
                onInput={(e) => setText(e.currentTarget.value)}
                placeholder="Start your discussion..."
                class="flex-1 bg-transparent text-monk-cream p-2 focus:outline-none h-32 resize-none"
              />
            </div>

            <Show when={imagePreview()}>
              <div class="relative">
                <img 
                  src={imagePreview()!} 
                  alt="Preview" 
                  class="max-h-48 w-auto rounded-lg"
                />
                <button
                  onClick={() => {
                    setImage(null);
                    setImagePreview(null);
                  }}
                  class="absolute top-1 right-1 bg-monk-red/80 text-white rounded-full p-1 hover:bg-monk-red"
                >
                  ✕
                </button>
              </div>
            </Show>

            <button
              onClick={handleCreateThread}
              disabled={isCreating()}
              class="w-full bg-monk-gold text-monk-blue py-3 rounded-lg hover:bg-monk-orange transition-colors disabled:opacity-50"
            >
              {isCreating() ? 'Creating...' : 'Create Thread'}
            </button>
          </div>
        </div>
      </div>
    </Show>
  );
};

export default NewThreadModal; 